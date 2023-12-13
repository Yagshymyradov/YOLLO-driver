import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/drop_down_menu.dart';
import '../../components/field_text.dart';
import '../../components/pick_poto.dart';
import '../../data/response.dart';
import '../../l10n/l10n.dart';
import '../../providers.dart';
import '../../utils/enums.dart';
import '../../utils/extensions.dart';
import '../../utils/navigation.dart';
import '../../utils/theme.dart';
import '../../utils/validators.dart';

class CreateOrder extends ConsumerStatefulWidget {
  const CreateOrder({super.key});

  @override
  ConsumerState<CreateOrder> createState() => _CreateOrderState();
}

class _CreateOrderState extends ConsumerState<CreateOrder> {
  final formKey = GlobalKey<FormState>();

  ValueNotifier<File?>? img = ValueNotifier<File?>(null);

  final usernameController = TextEditingController();
  final userPhoneController = TextEditingController();
  final userAddressController = TextEditingController();
  final userCommentController = TextEditingController();
  final amountController = TextEditingController();
  final tarifController = TextEditingController();
  final weightController = TextEditingController();
  final volumeSmController = TextEditingController();
  final maxSmController = TextEditingController();
  final minSmController = TextEditingController();
  final recipientNameController = TextEditingController();
  final recipientPhoneController = TextEditingController();

  bool inProgress = false;
  bool isValidate = false;

  List<RegionResults>? regions;
  List<RegionResults>? city;

  RegionResults? selectedSenderRegion;
  RegionResults? selectedRecipientRegion;
  RegionResults? selectedSenderCity;
  RegionResults? selectedRecipientCity;

  PaymentMethod? selectedPayment;

  void updateUi() {
    setState(() {
      //no-op
    });
  }

  Future<void> onCreateOrderButtonTab() async {
    updateUi();

    Keyboard.hide();

    if (!formKey.currentState!.validate()) {
      isValidate = true;
      return;
    }
    inProgress = true;

    final apiClient = ref.watch(apiClientProvider);
    try {
      await apiClient.createOrderBox(
        createOrderBox: CreateOrderBox(
          clientFrom: usernameController.text,
          clientTo: recipientNameController.text,
          phoneFrom: userPhoneController.text,
          phoneTo: recipientPhoneController.text,
          addressFrom: userAddressController.text,
          addressTo: '',
          tarif: tarifController.text,
          amount: amountController.text,
          weight: weightController.text,
          placeCount: 0,
          valuta: Currency.tmt,
          status: OrderStatus.call,
          comment: userCommentController.text,
          payment: selectedPayment?.asValue(context),
          regionFrom: selectedSenderRegion?.id.toString(),
          regionTo: selectedRecipientRegion?.id.toString(),
          discount: '0',
          volumeSm: volumeSmController.text,
          weightMax: '0',
          minSm: minSmController.text,
          maxSm: maxSmController.text,
          delivery: '0',
        ),
        img: img?.value?.path,
        file: img?.value,
      );
      if (mounted) {
        Navigator.pop(context);
        showSnackBar('Order created', backgroundColor: AppColors.greenColor);
      }
    } catch (e) {
      log(e.toString());
      if (mounted) {
        showSnackBar('Error', backgroundColor: AppColors.redColor);
      }
    }
    inProgress = false;
    updateUi();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.sendCargo),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
        bottom: const PreferredSize(
          preferredSize: Size(double.infinity, 20),
          child: Divider(color: AppColors.greyColor),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 90),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Center(
                child: Text(
                  l10n.sender,
                  style: appThemeData.textTheme.headlineLarge,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        FieldText(
                          hintText: context.l10n.fio,
                          controller: usernameController,
                          validator: (val) => Validator.emptyField(context, val),
                        ),
                        const SizedBox(height: 15),
                        FieldText(
                          hintText: '65343434',
                          prefixIcon: '+993',
                          controller: userPhoneController,
                          keyboardType: TextInputType.phone,
                          validator: (val) => Validator.phoneValidator(context, val),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(8),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 17),
                  PickPhoto(onSelectImg: img),
                ],
              ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final regionsHi = ref.watch(regionsHiProvider);
                  final results = regionsHi.asData?.value.results;
                  return DropDownMenu<RegionResults?>(
                    value: selectedSenderRegion,
                    borderColor: selectedSenderRegion == null && isValidate
                        ? AppColors.redColor
                        : AppColors.whiteColor,
                    validator: (v) => v == null ? context.l10n.chooseRegion : null,
                    values: results,
                    hint: l10n.selectRegion,
                    items: results?.map((e) {
                      return e.name;
                    }).toList(),
                    children: results
                        ?.map(
                          (e) => DropdownMenuItem<RegionResults?>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        selectedSenderRegion = val;
                        ref.read(regionsCityProvider(selectedSenderRegion!.name));
                        selectedSenderCity = null;
                        updateUi();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              Consumer(
                builder: (context, ref, child) {
                  final regionsCity =
                      ref.watch(regionsCityProvider(selectedSenderRegion?.name ?? '-'));
                  final results = regionsCity.asData?.value.results;
                  return DropDownMenu<RegionResults?>(
                    value: selectedSenderCity,
                    values: results,
                    isLoading: regionsCity.isLoading,
                    borderColor: selectedSenderCity == null && isValidate
                        ? AppColors.redColor
                        : AppColors.whiteColor,
                    validator: (v) {
                      v == null ? isValidate = true : isValidate = false;
                      return v == null ? context.l10n.chooseRegion : null;
                    },
                    hint: l10n.selectCity,
                    items: results?.map((e) {
                      return e.name;
                    }).toList(),
                    children: results
                        ?.map(
                          (e) => DropdownMenuItem<RegionResults?>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        selectedSenderCity = val;
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 12),
              FieldText(
                hintText: l10n.address,
                controller: userAddressController,
                validator: (value) => Validator.emptyField(context, value),
              ),
              const SizedBox(height: 12),
              FieldText(
                hintText: l10n.aboutProduct,
                controller: userCommentController,
                maxHeight: 80,
                maxLines: 3,
                validator: (value) => Validator.emptyField(context, value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                    child: FieldText(
                      hintText: l10n.price,
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FieldText(
                      hintText: l10n.delivery,
                      controller: tarifController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: DropDownMenu<PaymentMethod>(
                      fontSize: 12,
                      value: PaymentMethod.after,
                      values: PaymentMethod.values,
                      hint: l10n.payment,
                      items: PaymentMethod.values.map((e) {
                        return e.asValue(context);
                      }).toList(),
                      children: PaymentMethod.values
                          .map(
                            (e) => DropdownMenuItem<PaymentMethod>(
                              value: e,
                              child: Text(e.asValue(context)),
                            ),
                          )
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          selectedPayment = val;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.weight,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: l10n.kg,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.kg,
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.volume,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),
                        ),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: l10n.m3,
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.sm(30),
                      controller: volumeSmController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.sm(30),
                      controller: maxSmController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.sm(40),
                      controller: minSmController,
                      keyboardType: TextInputType.number,
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                l10n.recipient,
                style: appThemeData.textTheme.headlineMedium,
              ),
              const SizedBox(height: 13),
              FieldText(
                hintText: l10n.fio,
                controller: recipientNameController,
                validator: (value) => Validator.emptyField(context, value),
              ),
              const SizedBox(height: 13),
              FieldText(
                hintText: '65343434',
                prefixIcon: '+993',
                controller: recipientPhoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [LengthLimitingTextInputFormatter(8)],
                validator: (value) => Validator.emptyField(context, value),
              ),
              const SizedBox(height: 13),
              Consumer(
                builder: (context, ref, child) {
                  final regionsHi = ref.watch(regionsHiProvider);
                  final results = regionsHi.asData?.value.results;
                  return DropDownMenu<RegionResults?>(
                    borderColor: selectedRecipientRegion == null && isValidate
                        ? AppColors.redColor
                        : AppColors.whiteColor,
                    validator: (val) => Validator.unSelected(
                      context,
                      val,
                      l10n.chooseCity,
                    ),
                    value: selectedRecipientRegion,
                    values: results,
                    hint: l10n.selectRegion,
                    items: results?.map((e) {
                      return e.name ?? '-';
                    }).toList(),
                    children: results
                        ?.map(
                          (e) => DropdownMenuItem<RegionResults?>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        selectedRecipientRegion = val;
                        ref.read(regionsCityProvider(selectedRecipientRegion!.name));
                        updateUi();
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 13),
              Consumer(
                builder: (context, ref, child) {
                  final regionsCity =
                      ref.watch(regionsCityProvider(selectedRecipientRegion?.name ?? '-'));
                  final results = regionsCity.asData?.value.results;
                  return DropDownMenu<RegionResults?>(
                    borderColor: selectedRecipientCity == null && isValidate
                        ? AppColors.redColor
                        : AppColors.whiteColor,
                    validator: (val) => Validator.unSelected(context, val, l10n.chooseCity),
                    value: selectedRecipientCity,
                    values: results,
                    isLoading: regionsCity.isLoading,
                    hint: l10n.selectCity,
                    items: results?.map((e) {
                      return e.name;
                    }).toList(),
                    children: results
                        ?.map(
                          (e) => DropdownMenuItem<RegionResults?>(
                            value: e,
                            child: Text(e.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        selectedRecipientCity = val;
                      }
                    },
                  );
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    inProgress ? const CircularProgressIndicator() : onCreateOrderButtonTab(),
                child: Text(
                  l10n.saveIt,
                  style: appThemeData.textTheme.displayMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
