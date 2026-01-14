import 'package:flutter/material.dart';

/// App theme, color palette and typography for a medical diagnostic AI platform.
///
/// Palette focuses on calm, clinical blues/teals with a warm accent for
/// highlights and CTAs. Uses `Inter` as the recommended font family for
/// legibility — add it in `pubspec.yaml` or use Google Fonts package.

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF0B6FA4); // calming deep blue
  static const Color primaryVariant = Color(0xFF084E74);
  static const Color secondary = Color(0xFF17A398); // cool teal
  static const Color accent = Color(0xFFF39C12); // warm amber for highlights
  static const Color background = Color(0xFFF5F9FB); // very light blue-gray
  static const Color surface = Color(0xFFFFFFFF);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onBackground = Color(0xFF102330); // dark slate
  static const Color success = Color(0xFF2E7D32);
  static const Color error = Color(0xFFC62828);
}

class AppTypography {
  AppTypography._();

  // Recommended font family. Add `Inter` to assets or use Google Fonts.
  static const String fontFamily = 'Inter';

  // Sizes chosen for clarity and accessibility (recommended base scale).
  // Use `bodyLarge` (16) and `bodyMedium` (14) for most text; larger sizes
  // for headings and important labels.
  static final TextTheme textTheme = TextTheme(
    displayLarge: const TextStyle(fontSize: 96, fontWeight: FontWeight.bold),
    displayMedium: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
    displaySmall: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
    headlineLarge: const TextStyle(fontSize: 34, fontWeight: FontWeight.w700),
    headlineMedium: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
    headlineSmall: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
    titleLarge: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
    bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
    bodyMedium: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
    labelLarge: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    labelSmall: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
  ).apply(fontFamily: fontFamily);
}

class AppTheme {
  AppTheme._();

  static ThemeData light() {
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      onSecondary: Colors.white,
      error: AppColors.error,
      onError: Colors.white,
      background: AppColors.background,
      onBackground: AppColors.onBackground,
      surface: AppColors.surface,
      onSurface: AppColors.onBackground,
    );

    return ThemeData(
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        elevation: 1,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.secondary,
        foregroundColor: Colors.white,
      ),
      textTheme: AppTypography.textTheme,
      primaryTextTheme: AppTypography.textTheme,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      useMaterial3: true,
    );
  }
}
