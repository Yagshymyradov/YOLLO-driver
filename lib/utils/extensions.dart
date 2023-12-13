import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/l10n.dart';


extension Keyboard on Never {
  static void hide() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

late final _dateFormat = DateFormat('dd.MM.y', 'en');

String dateTime(DateTime dateTime, BuildContext context) {
  final Duration timePassed = DateTime.now().difference(dateTime);

  final minutesDiff = timePassed.inMinutes;

  if (minutesDiff == 0) {
    return context.l10n.justNow;
  }

  if (minutesDiff < 60) {
    return context.l10n.lastTimeInMinutes(minutesDiff);
  }

  final hoursDiff = timePassed.inHours;
  if (hoursDiff < 12) {
    return context.l10n.lastTimeInHours(hoursDiff);
  }

  final String createdAt = _dateFormat.format(dateTime);
  return createdAt;
}

extension DoubleX on double {
  /// rounds the double to a specific decimal place
  double roundedPrecision(int decimals) {
    final double mod = math.pow(10.0, decimals).toDouble();
    return (this * mod).round().toDouble() / mod;
  }

  String roundedPrecisionString({int decimals = 2, bool removeZeroDecimals = true}) {
    final result = roundedPrecision(decimals);
    if (removeZeroDecimals && (result - result.truncate()) == 0.0) {
      // ignore: parameter_assignments
      decimals = 0;
    }
    return result.toStringAsFixed(decimals);
  }
}