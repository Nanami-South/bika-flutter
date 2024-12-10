import 'package:flutter/material.dart';

class AppColors {
  // 浅色模式
  static const Color lightBackground = Color(0xFFFFFFFF);
  static const Color lightPrimary = Color(0xFFEB74A0);
  static const Color lightOnPrimary = Color(0xFFF0F0F0);
  static const Color lightSecondary = Color(0xFF999999);
  static const Color lightOnSecondary = Color(0xFFF0F0F0);
  static const Color lightSurface = Color(0xFFF0F0F0);
  static const Color lightOnSurface = Color(0xFFEB74A0);

  // 深色模式
  static const Color darkBackground = Color(0xFF1C1C1C);
  static const Color darkSurface = Color(0xFF2D2D2D);
  static const Color darkPrimary = Color(0xFFEB74A0);
  static const Color darkOnPrimary = Color(0xFF1C1C1C);
  static const Color darkSecondary = Color(0xFF666666);
  static const Color darkOnSecondary = Color(0xFF2D2D2D);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
}

Color bgColor(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? AppColors.darkBackground
      : AppColors.lightBackground;
}

ThemeData getLightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: AppColors.lightPrimary,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      onPrimary: AppColors.lightOnPrimary,
      secondary: AppColors.lightSecondary,
      onSecondary: AppColors.lightOnSecondary,
      surface: AppColors.lightSurface,
      onSurface: AppColors.lightOnSurface,
    ),
  );
}

ThemeData getDarkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.darkPrimary,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkSecondary,
      surface: AppColors.darkSurface,
    ),
  );
}
