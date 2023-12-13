import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

import '../utils/assets.dart';
import '../utils/theme.dart';

class DropDownMenu<T> extends StatelessWidget {
  DropDownMenu({
    Key? key,
    required this.value,
    required this.values,
    this.fontSize = 14,
    this.isLoading = false,
    this.onChanged,
    required this.hint,
    this.items,
    required this.children,
    this.validator,
    this.borderColor = AppColors.whiteColor,
  }) : super(key: key);
  late T value;
  final List<T>? values;
  final double fontSize;
  final bool isLoading;
  final List<String>? items;
  final List<DropdownMenuItem<T>>? children;
  void Function(T?)? onChanged;
  final String hint;
  final Color borderColor;
  final String? Function(T?)? validator;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      alignedDropdown: true,
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField2<T>(
          isExpanded: true,
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.only(right: 15),
            height: 42,
            decoration: BoxDecoration(
              border: Border.all(
                color: borderColor,
              ),
              borderRadius: BorderRadius.circular(23),
            ),
          ),
          iconStyleData: IconStyleData(
            icon: isLoading
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: CircularProgressIndicator.adaptive(strokeWidth: 1.8),
                  )
                : AppIcons.chevronDown.svgPicture(),
          ),
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(23)),
            enabledBorder: _border(AppColors.whiteColor),
            errorBorder: _border(AppColors.redColor),
            focusedBorder: _border(AppColors.blueColor),
            errorStyle: const TextStyle(color: AppColors.redColor),
          ),
          validator: validator,
          // dropdownColor: Colors.black87,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: fontSize,
          ),
          selectedItemBuilder: (context) {
            return List.generate(
              items?.length ?? 0,
              (index) => Text(
                items?[index] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
          value: value,
          hint: value == null
              ? Text(
                  hint,
                  style: const TextStyle(color: Colors.white),
                )
              : null,
          items: children,
          onChanged: onChanged,
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color) {
    return OutlineInputBorder(borderRadius: BorderRadius.circular(23), borderSide: BorderSide.none);
  }
}
