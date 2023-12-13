import 'package:flutter/material.dart';

import '../data/response.dart';
import '../l10n/l10n.dart';

class Validator {
  static String? emptyField(
    BuildContext context,
    String? value,
  ) {
    if (value == null) {
      return null;
    }
    final trimmedValue = value.trimRight();
    if (trimmedValue.isEmpty) {
      return /*emptyMessage ?? */context.l10n.fillBlank;
    }
    return null;
  }

  static String? unSelected(
      BuildContext context,
      RegionResults? value,
      String? emptyMessage,
      ) {
    if (value == null) {
      return emptyMessage;
    }
    // final trimmedValue = value;
    // if (trimmedValue) {
    //   return emptyMessage;
    // }
    return null;
  }

  static String? phoneValidator(BuildContext context, String? value) {
    final l10n = context.l10n;

    if (value == null || value.isEmpty) return l10n.writePhoneNumber;

    final trimmedValue = value.trim();
    if (value.length >= 2 || trimmedValue.length < 8) {
      const allowedPhonePrefixes = ['61', '62', '63', '64', '65', '70', '71'];
      if (allowedPhonePrefixes.contains(value.substring(0, 2))) {
        return null;
      }
    }
    return l10n.inCorrectPhoneNumber;
  }
}
