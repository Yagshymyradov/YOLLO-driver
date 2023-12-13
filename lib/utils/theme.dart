import 'package:flutter/material.dart';

final appThemeData = ThemeData(
  useMaterial3: true,
  brightness: Brightness.dark,
  appBarTheme: const AppBarTheme(
    elevation: 0,
    backgroundColor: Colors.transparent,
    centerTitle: true,
    titleTextStyle: TextStyle(
      color: AppColors.whiteColor,
      fontSize: 20,
      fontWeight: FontWeight.w700,
    ),
  ),
  scaffoldBackgroundColor: AppColors.darkColor,
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor,
    ),
    displayMedium: TextStyle(
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: AppColors.whiteColor,
    ),
    bodySmall: TextStyle(
      color: AppColors.greyColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodyMedium: TextStyle(
      color: AppColors.whiteColor,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
   headlineMedium: TextStyle(
     fontSize: 17,
     fontWeight: FontWeight.w700,
     color: AppColors.blueColor,
   ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23),
        ),
      ),
      backgroundColor: const MaterialStatePropertyAll(AppColors.blueColor),
      minimumSize: MaterialStateProperty.all(const Size(double.infinity, 40)),
    ),
  ),
);

class AppColors {
  AppColors._();

  static const darkColor = Color.fromRGBO(23, 25, 26, 1);
  static const whiteColor = Color.fromRGBO(255, 255, 255, 1);
  static const lightColor = Color.fromRGBO(239, 242, 245, 1);
  static const darkGreyColor = Color.fromRGBO(151, 151, 151, 1);
  static const greyColor = Color.fromRGBO(179, 179, 179, 1);
  static const lightGreyColor = Color.fromRGBO(203, 203, 203, 1);
  static const blueColor = Color.fromRGBO(56, 152, 243, 1);
  static const greenColor = Color.fromRGBO(84, 181, 65, 1);
  static const redColor = Color.fromRGBO(214, 35, 0, 1);
  static const backgroundColor = Color.fromRGBO(23, 25, 26, 1);
  static const buttonColor = Color.fromRGBO(41, 163, 238, 1);
  static const boldBlueColor = Color.fromRGBO(56, 152, 243, 1);
  static const greenColorWO = Color.fromRGBO(67, 199, 72, 0.96);
}
