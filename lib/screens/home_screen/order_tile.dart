import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/response.dart';
import '../../providers.dart';
import '../../utils/assets.dart';
import '../../utils/enums.dart';
import '../../utils/extensions.dart';
import '../../utils/navigation.dart';
import '../../utils/theme.dart';
import 'order_detail.dart';
import 'order_set_up_detail.dart';

class OrderTile extends ConsumerWidget {
  final OrdersBox order;

  const OrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final driverType = ref.watch(authControllerProvider)?.driverType;
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () {
        if (order.id != null) {
          navigateToScreen(
            context,
            driverType == DriverType.driver.asValue()
                ? OrderSetUpDetail(orderId: order.id)
                : OrderDetail(orderId: order.id),
          );
        }
      },
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 80,
                child: Image.network(
                  'https://yollo.com.tm${order.boxImg}',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '#${order.id}',
                      style: appThemeData.textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 5),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: order.regionFromName,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w100,
                            ),
                          ),
                          if (order.regionToName != null)
                            TextSpan(
                              text: '-${order.regionToName}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          order.amount!.roundedPrecisionString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                            color: AppColors.blueColor,
                          ),
                        ),
                        Text(
                          order.tarif!.roundedPrecisionString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          order.payment.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Text(
                    dateTime(order.inputDate!, context),
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: AppColors.darkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppIcons.arrowRight.svgPicture(),
                ],
              ),
            ],
          ),
          const Divider(color: AppColors.lightColor),
        ],
      ),
    );
  }
}
