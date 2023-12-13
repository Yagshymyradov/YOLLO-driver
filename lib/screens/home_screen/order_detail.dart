import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../components/field_box.dart';
import '../../components/field_text.dart';
import '../../data/response.dart';
import '../../l10n/l10n.dart';
import '../../providers.dart';
import '../../utils/enums.dart';
import '../../utils/extensions.dart';
import '../../utils/navigation.dart';
import '../../utils/theme.dart';

final ordersByIdProvider = FutureProvider.family.autoDispose((ref, int id) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getOrdersBoxById(id);
});

class OrderDetail extends ConsumerStatefulWidget {
  final int? orderId;

  const OrderDetail({super.key, required this.orderId});

  @override
  ConsumerState<OrderDetail> createState() => _OrderDetailState();
}

class _OrderDetailState extends ConsumerState<OrderDetail> {
  TextEditingController? commentController = TextEditingController();

  List<RegionResults>? regions;
  List<RegionResults>? city;

  RegionResults? selectedRegion;
  RegionResults? selectedCity;

  PaymentMethod? selectedPayment;
 
  bool inProgressRejecting = false;
  bool inProgressDelivered = false;
  void updateUi() {
    setState(() {
      //no-op
    });
  }

  Future<void> onChangeStatusButtonTab(String status) async{
    Keyboard.hide();

    if(status == 'rejected') {
      inProgressRejecting = true;
    }else {
      inProgressDelivered = true;
    }
    updateUi();
    
    final apiClient = ref.read(apiClientProvider);
    
    try{
      await apiClient.setOrderBoxStatus(
        id: widget.orderId!,
        comment: commentController?.text,
        status: status,
      );
      if(mounted){
        showSnackBar('Uytgedildi' ,backgroundColor: AppColors.greenColor);
      }
    } catch(e){
      if(mounted){
        showSnackBar('Nasazlyk yuze cykdy');
      }
    }
    
    inProgressRejecting = false;
    inProgressDelivered = false;
    updateUi();
  }

  Future<void> onCallTab(String phone) async {
    final Uri url = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final orderById = ref.watch(ordersByIdProvider(widget.orderId ?? 1));
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          l10n.follow,
          style: const TextStyle(color: AppColors.whiteColor),
        ),
      ),
      body: orderById.when(
        data: (data) {
          final item = data.box;
          return ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 90),
            children: [
              Container(
                height: 320,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadiusDirectional.circular(26),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(26),
                  child: Image.network(
                    'https://yollo.com.tm${item?.boxImg}',
                    fit: BoxFit.cover,
                  ),
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
                      text: item?.addressTo,
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
                onPressed: () =>onCallTab(item?.phoneFrom ?? ''),
                child: Text(
                  item?.phoneFrom ?? 'Belgi yok',
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              ElevatedButton(
                onPressed: () {},
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(AppColors.greenColor),
                ),
                child: Text(
                  item?.phoneTo ?? 'Belgi yok',
                  style: const TextStyle(
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
              const SizedBox(height: 13),
              Row(
                children: [
                  Expanded(
                    child: FiledBox(title: item?.regionFromName ?? 'Gorkezilmedik'),
                  ),
                  const SizedBox(width: 13),
                  Expanded(
                    child: FiledBox(title: item?.regionToName ?? 'Gorkezilmedik'),
                  ),
                ],
              ),
              const SizedBox(height: 13),
              FiledBox(
                title: item?.comment ?? 'Gorkezilmedik',
                height: 80,
                alignment: Alignment.topLeft,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Flexible(
                    child: FiledBox(
                      title: item?.amount?.roundedPrecisionString() ?? 'Gorkezilmedik',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FiledBox(
                      title: item?.tarif?.roundedPrecisionString() ?? 'Gorkezilmedik',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: FiledBox(
                      title: item?.payment ?? 'Gorkezilmedik',
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const WidgetSpan(child: SizedBox(width: 10)),
                        TextSpan(
                          text: l10n.kg,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 30),
                  Expanded(
                    child: FiledBox(
                      title:
                          '${item?.weight ?? 'Gorkezilmedik'} ${item?.weight != null ? l10n.kg : ''}',
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
                    child: FiledBox(
                      title: item?.volumeSm ?? 'bos',
                      height: 38,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FiledBox(
                      title: item?.maxSm ?? 'bos',
                      height: 38,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: FiledBox(
                      title: item?.minSm ?? 'bos',
                      height: 38,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              FieldText(
                controller: commentController,
                hintText: 'Suruji sebap yazmaly',
                maxLines: 3,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () =>onChangeStatusButtonTab('rejected'),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppColors.redColor),
                      ),
                      child: const Text(
                        'Gaytaryldy',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 30),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () => onChangeStatusButtonTab('delivered'),
                      style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(AppColors.greenColor),
                      ),
                      child: const Text(
                        'Tamamlandy',
                        style: TextStyle(
                          color: AppColors.whiteColor,
                        ),
                      ),
                    ),
                  ),
                ],
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
