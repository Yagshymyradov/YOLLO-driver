import 'package:flutter/material.dart';

import '../l10n/l10n.dart';

enum Currency {
  tmt,
  usd;

  String asValue() {
    switch (this) {
      case Currency.tmt:
        return 'TMT';
      case Currency.usd:
        return 'USD';
    }
  }
}

enum OrderStatus { call }

enum PaymentMethod {
  before,
  after;

  String asValue(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case PaymentMethod.before:
        return l10n.before;
      case PaymentMethod.after:
        return l10n.after;
    }
  }
}

enum DriverType{
  driver,
  wdirver;

  String asValue(){
    switch(this){
      case DriverType.driver:
        return 'driver';
      case DriverType.wdirver:
        return 'wdriver';
    }
  }
}
