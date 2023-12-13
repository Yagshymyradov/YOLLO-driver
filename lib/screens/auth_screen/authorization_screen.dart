import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../components/field_text.dart';
import '../../data/exceptions.dart';
import '../../l10n/l10n.dart';
import '../../providers.dart';
import '../../utils/assets.dart';
import '../../utils/extensions.dart';
import '../../utils/navigation.dart';
import '../../utils/theme.dart';
import '../../utils/validators.dart';
import '../main_screen.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool inProgress = false;

  void updateUi() {
    if (mounted) {
      setState(() {
        //no-op
      });
    }
  }

  Future<void> onSignInTap() async {
    Keyboard.hide();

    if (!formKey.currentState!.validate()) {
      return;
    }

    final scope = ProviderScope.containerOf(context, listen: false);
    final apiClient = scope.read(apiClientProvider);
    final authController = scope.read(authControllerProvider.notifier);

    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    inProgress = true;
    updateUi();

    try {
      final response = await apiClient.signIn(
        username: username,
        password: password,
      );
      await authController.onSignedIn(response);
      if (mounted) {
        await replaceRootScreen<Widget>(context, const MainScreen());
      }
    } catch (e) {
      log(e.toString());
      if (mounted) {
        final String message;
        if (e is HttpStatusException && e.code == 401) {
          message = 'Beyle ulanyjy yok';
        } else {
          message = 'Bir yalnyslyk bar';
        }
        showErrorSnackBar(message);
      }
    }
    inProgress = false;
    updateUi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Içeri gir'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 78),
              AppIcons.logo.svgPicture(),
              const SizedBox(height: 46),
              FieldText(
                validator: (value) => Validator.emptyField(context, value),
                controller: usernameController,
                hintText: context.l10n.username,
              ),
              const SizedBox(height: 20),
              FieldText(
                validator: (value) => Validator.emptyField(context, value),
                hintText: context.l10n.password,
                controller: passwordController,
              ),
              const SizedBox(height: 55),
              ElevatedButton(
                onPressed: inProgress ? null : onSignInTap,
                style: appThemeData.elevatedButtonTheme.style,
                child: inProgress
                    ? const CircularProgressIndicator()
                    : const Text(
                        'Iceri gir',
                        style: TextStyle(
                          fontSize: 18,
                          color: AppColors.whiteColor,
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
