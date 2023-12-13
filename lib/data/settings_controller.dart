// ignore_for_file: constant_identifier_names

import 'dart:ui';

import 'package:state_notifier/state_notifier.dart';

import '../l10n/l10n.dart' as l10n show FallbackLocale, toSupportedLocaleByCode;
import 'service/preferences.dart';

class AppSettings {
  final Locale locale;

  AppSettings({
    required this.locale,
  });

  AppSettings copyWith({
    Locale? locale,
  }) {
    return AppSettings(
      locale: locale ?? this.locale,
    );
  }
}

class SettingsController extends StateNotifier<AppSettings> {
  static const _LocaleCode = 'locale';

  final AppPrefsService _service;

  Locale get locale => state.locale;

  SettingsController(this._service, super.state);

  static AppSettings initialize(AppPrefsService service) {
    Locale locale = l10n.FallbackLocale;

    try {
      final persisted = service.getString(_LocaleCode);
      if (persisted != null) locale = l10n.toSupportedLocaleByCode(persisted);
    } catch (e) {
      //ignored
    }


    return AppSettings(
      locale: locale,
    );
  }

  void updateLocale(Locale? newLocale) {
    // ignore: parameter_assignments
    newLocale ??= l10n.FallbackLocale;

    final oldState = state;
    if (oldState.locale == newLocale) return;
    _service.setString(_LocaleCode, newLocale.languageCode);
    state = oldState.copyWith(locale: newLocale);
  }

}
