import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers.dart';
import '../utils/assets.dart';
import '../utils/navigation.dart';
import '../utils/theme.dart';
import 'auth_screen/authorization_screen.dart';
import 'main_screen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final animController = AnimationController(vsync: this);

  void replaceWithRootScreen() {
    final authState = ProviderScope.containerOf(context, listen: false)
        .read(authControllerProvider);
    if (authState != null) {
      replaceRootScreen(context, const MainScreen());
    } else {
      replaceRootScreen(context, const AuthorizationScreen());
    }
  }

  @override
  void initState() {
    super.initState();

    animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        replaceWithRootScreen();
      }
    });

    animController
      ..duration = const Duration(seconds: 2)
      ..forward();
  }

  @override
  void dispose() {
    animController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Center(
        child: AppIcons.logo.svgPicture(),
      ),
    );
  }
}
