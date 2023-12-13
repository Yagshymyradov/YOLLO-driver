import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/drop_down_menu.dart';
import '../../components/field_text.dart';
import '../../components/pick_poto.dart';
import '../../data/api_client.dart';
import '../../data/response.dart';
import '../../l10n/l10n.dart';
import '../../providers.dart';
import '../../utils/enums.dart';
import '../../utils/extensions.dart';
import '../../utils/navigation.dart';
import '../../utils/theme.dart';
import '../../utils/validators.dart';

final ordersByIdProvider = FutureProvider.family.autoDispose((ref, int id) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getOrdersBoxById(id);
});

class OrderSetUpDetail extends ConsumerStatefulWidget {
  final int? orderId;

  const OrderSetUpDetail({super.key, required this.orderId});

  @override
  ConsumerState<OrderSetUpDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends ConsumerState<OrderSetUpDetail> {
  final formKey = GlobalKey<FormState>();

  ValueNotifier<File?>? img = ValueNotifier<File?>(null);

  final userCommentController = TextEditingController();
  final amountController = TextEditingController();
  final tarifController = TextEditingController();
  final weightController = TextEditingController();
  final volumeSmController = TextEditingController();
  final maxSmController = TextEditingController();
  final minSmController = TextEditingController();
  final recipientPhoneController = TextEditingController();

  bool inProgress = false;
  bool isValidate = false;

  List<RegionResults>? regions;
  List<RegionResults>? city;

  RegionResults? selectedSenderRegion;
  RegionResults? selectedSenderCity;
  RegionResults? selectedRecipientRegion;
  RegionResults? selectedRecipientCity;

  PaymentMethod? selectedPayment;

  void updateUi() {
    setState(() {
      //no-op
    });
  }

  Future<void> onCreateOrderButtonTab(OrderDetails order) async {

    final item = order.box!;
    inProgress = true;

    updateUi();

    Keyboard.hide();

      log('does not work');
    if (!formKey.currentState!.validate()) {
      log('does not work1');
      return;
    }
      log('does not work2');

    final apiClient = ref.read(apiClientProvider);
    try {
      await apiClient.updateOrderBox(
        id: widget.orderId!,
        createOrderBox: CreateOrderBox(
          clientFrom: item.clientFrom,
          clientTo: item.clientTo,
          phoneFrom: item.phoneFrom,
          phoneTo: recipientPhoneController.text,
          addressFrom: item.addressFrom,
          addressTo: item.addressTo,
          tarif: tarifController.text,
          amount: amountController.text,
          weight: weightController.text,
          placeCount: 0,
          valuta: Currency.tmt,
          status: OrderStatus.call,
          comment: userCommentController.text,
          payment: selectedPayment?.asValue(context),
          //TODO fix it
          regionFrom: selectedSenderRegion?.id.toString() ?? '8',
          regionTo: selectedRecipientRegion!.id.toString() ?? '1',
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
    } catch (e, s) {
      log(s.toString());
      if (mounted) {
        showSnackBar(e.toString(), backgroundColor: AppColors.redColor);
      }
    }
    inProgress = false;
    updateUi();
  }

  // @override
  // void initState() {
  //   init();
  //   super.initState();
  // }

  Future<void> init() async{
    log('message');
    final orderById = ref.read(ordersByIdProvider(widget.orderId!));

    log('widget.orderId-->> ${widget.orderId}');
    final box = orderById.asData?.value.box;
    log('box-->> $box');
    amountController.text = box?.amount.toString() ?? 'null';
    log('1---${amountController.text}');
    tarifController.text = box?.tarif.toString() ?? 'null';
    log('2---${tarifController.text}');
    weightController.text = box?.weight.toString() ?? 'null';
    log('3---${weightController.text}');
    volumeSmController.text = box?.volumeSm.toString() ?? 'null';
    log('4---${volumeSmController.text}');
    maxSmController.text = box?.maxSm.toString() ?? 'null';
    log('5---${maxSmController.text}');
    minSmController.text = box?.minSm.toString() ?? 'null';
    log('6---${minSmController.text}');
    recipientPhoneController.text = box?.phoneTo ?? 'null';
    log('7---${recipientPhoneController.text}');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final orderById = ref.watch(ordersByIdProvider(widget.orderId!));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(l10n.follow),
      ),
      body: orderById.when(
        data: (data) {
          final item = data.box;
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: PickPhoto(
                  height: 290,
                  initialImg: Image.network(
                    '${Endpoints.baseUrl}${item?.boxImg}',
                    fit: BoxFit.cover,
                  ),
                  onSelectImg: img,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '#${item?.id}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueColor,
                    ),
                  ),
                  Text(
                    dateTime(item?.inputDate ?? DateTime.now(), context),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: item?.regionFromName,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const WidgetSpan(child: SizedBox(width: 22)),
                    TextSpan(
                      text: item?.regionToName,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 13),
              ElevatedButton(
                onPressed: () {},
                child: Text(
                  item!.phoneFrom!,
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              FieldText(
                keyboardType: TextInputType.phone,
                controller: recipientPhoneController,
                validator: (value) => Validator.phoneValidator(context, value),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final regionsHi = ref.watch(regionsHiProvider);
                        final results = regionsHi.asData?.value.results;
                        return DropDownMenu<RegionResults?>(
                          borderColor: selectedSenderRegion == null ? AppColors.redColor : AppColors.whiteColor,
                          validator: (val) => Validator.unSelected(
                            context,
                            val,
                            l10n.chooseRegion,
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
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: Consumer(
                      builder: (context, ref, child) {
                        final regionsCity =
                            ref.watch(regionsCityProvider(selectedRecipientRegion?.name ?? '-'));
                        final results = regionsCity.asData?.value.results;
                        return DropDownMenu<RegionResults?>(
                          borderColor: selectedSenderRegion == null ? AppColors.redColor : AppColors.whiteColor,
                          validator: (val) => Validator.unSelected(
                            context,
                            val,
                            l10n.chooseCity,
                          ),
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
                  ),
                ],
              ),
              const SizedBox(height: 13),
              FieldText(
                hintText: l10n.aboutProduct,
                maxHeight: 80,
                maxLines: 3,
                controller: userCommentController..text = item.comment ?? '',
                validator: (value) => Validator.emptyField(context, value),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                    child: FieldText(
                      hintText: l10n.price,
                      keyboardType: TextInputType.number,
                      controller: amountController
                        ..text = item.amount?.roundedPrecisionString() ?? '',
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FieldText(
                      hintText: l10n.delivery,
                      keyboardType: TextInputType.number,
                      controller: tarifController
                        ..text = item.tarif?.roundedPrecisionString() ?? '',
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: DropDownMenu<PaymentMethod>(
                      fontSize: 12,
                      value: item.payment == 'Soňundan' || item.payment == 'После'
                          ? PaymentMethod.after
                          : PaymentMethod.before,
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
                      controller: weightController..text = item.weight ?? '',
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: l10n.m3,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.sm(30),
                      controller: volumeSmController..text = item.volumeSm ?? '',
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.sm(30),
                      controller: maxSmController..text = item.maxSm ?? '',
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FieldText(
                      verticalPadding: 8,
                      hintText: l10n.sm(40),
                      controller: minSmController..text = item.minSm ?? '',
                      validator: (value) => Validator.emptyField(context, value),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => inProgress ? null : onCreateOrderButtonTab(data),
                child: inProgress
                    ? const CircularProgressIndicator()
                    : Text(
                        l10n.saveIt,
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
              ),
            ],
          );
        },
        error: (error, stack) {
          log(error.toString());
          return Text(error.toString());
        },
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
