import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/theme.dart';

class FieldText extends StatelessWidget {
  final double? maxHeight;
  final double? verticalPadding;
  final int? maxLines;
  final String? prefixIcon;
  final bool password;
  final String? labelText;
  final String? hintText;
  final TextEditingController? controller;
  final bool obscureText;
  final VoidCallback? onTogglePasscodeVisibilityTap;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? initialValue;
  final List<TextInputFormatter>? inputFormatters;

  const FieldText({
    super.key,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.password = false,
    this.onTogglePasscodeVisibilityTap,
    this.validator,
    this.hintText,
    this.prefixIcon,
    this.maxHeight,
    this.maxLines,
    this.verticalPadding,
    this.keyboardType,
    this.initialValue,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    final displayMediumText = appThemeData.textTheme.bodySmall;
    return TextFormField(
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
      controller: controller,
      style: displayMediumText,
      maxLines: maxLines ?? 1,
      initialValue: initialValue,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 22, vertical: verticalPadding ?? 12),
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.only(left: 22),
                child: Text(
                  prefixIcon!,
                  style: displayMediumText,
                ),
              )
            : null,
        prefixIconConstraints: const BoxConstraints(minHeight: 0),
        hintText: hintText,
        labelText: labelText,
        suffixIcon: password
            ? IconButton(
                onPressed: onTogglePasscodeVisibilityTap,
                icon: obscureText
                    ? const Icon(
                        Icons.remove_red_eye_outlined,
                        size: 24,
                        color: AppColors.greyColor,
                      )
                    : const Icon(
                        Icons.remove_red_eye_outlined,
                        size: 24,
                        color: AppColors.greyColor,
                      ),
                splashRadius: 22,
                padding: EdgeInsets.zero,
              )
            : null,
        labelStyle: displayMediumText,
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (states) {
            final Color color = states.contains(MaterialState.focused)
                ? AppColors.boldBlueColor
                : AppColors.greyColor;
            return TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
            );
          },
        ),
        errorStyle: const TextStyle(color: AppColors.redColor),
        border: buildOutlineInputBorder(AppColors.whiteColor),
        focusedBorder: buildOutlineInputBorder(AppColors.blueColor),
        focusedErrorBorder: buildOutlineInputBorder(AppColors.redColor),
        errorBorder: buildOutlineInputBorder(AppColors.redColor),
      ),
    );
  }

  OutlineInputBorder buildOutlineInputBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(23),
      borderSide: BorderSide(color: color),
    );
  }
}
