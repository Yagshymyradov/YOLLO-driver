import 'package:flutter/material.dart';
import '../utils/theme.dart';

class FiledBox extends StatelessWidget {
  final String title;
  final double height;
  final Alignment alignment;

  const FiledBox({
    super.key,
    required this.title,
    this.height = 43,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      padding: const EdgeInsets.all(8),
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(23),
        border: Border.all(color: AppColors.greyColor),
      ),
      child: SingleChildScrollView(child: Text(title)),
    );
  }
}
