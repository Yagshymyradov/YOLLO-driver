import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../screens/home_screen/create_order.dart';
import '../utils/assets.dart';
import '../utils/navigation.dart';
import '../utils/theme.dart';
class CreateOrderManually extends StatelessWidget {
  const CreateOrderManually({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return ListTile(
      splashColor: AppColors.blueColor,
      contentPadding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.circular(8),
        side: const BorderSide(color: AppColors.lightGreyColor),
      ),
      onTap: ()=> navigateToScreen(context, const CreateOrder()),
      title: Text(
        l10n.sendCargo,
        style: appThemeData.textTheme.displayLarge,
      ),
      subtitle: Text(
        l10n.completeOrder,
        style: appThemeData.textTheme.displayMedium,
      ),
      trailing: AppIcons.box.svgPicture(),
    );
  }
}
