import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/outlined_dropdown_button_form_field.dart';
import '../../l10n/l10n.dart';
import '../../providers.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final username = ref.watch(authControllerProvider)?.username;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 100),
            Center(
              child: AppIcons.profile.svgPicture(
                color: AppColors.blueColor,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              username!,
              style: appThemeData.textTheme.displayLarge,
            ),
            const SizedBox(height: 30),
            OutlineDropdownButtonFormField<Locale>(
              elevation: 1,
              icon: AppIcons.chevronDown.svgPicture(),
              decoration: InputDecoration(
                labelText: l10n.language,
                labelStyle: const TextStyle(
                  color: AppColors.greyColor,
                  fontWeight: FontWeight.w500,
                ),
                border: const OutlineInputBorder(),
                contentPadding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              ),
              value: Localizations.localeOf(context),
              items: AppLocalizations.supportedLocales
                  .map(
                    (locale) => DropdownMenuItem(
                      value: locale,
                      child: Text(
                        AppLocalizationsX.getLocaleName(locale),
                        style: appThemeData.textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (newLocale) {
                if (newLocale != null) {
                  ref.read(settingsControllerProvider.notifier).updateLocale(newLocale);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
