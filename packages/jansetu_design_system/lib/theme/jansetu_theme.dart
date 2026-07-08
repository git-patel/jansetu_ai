import 'package:flutter/material.dart';
import 'jansetu_colors.dart';

/// Official Material 3 Theme Data for JanSetu AI
/// Supports 8dp grid system and responsive typography across mobile and web.
class JanSetuTheme {
  JanSetuTheme._();

  // 8dp Spatial Grid Constants
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space48 = 48.0;

  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;

  // Light Theme Configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: JanSetuColors.electricBlue,
        brightness: Brightness.light,
        primary: JanSetuColors.electricBlue,
        onPrimary: Colors.white,
        secondary: JanSetuColors.slateNavy,
        surface: JanSetuColors.lightBg,
        error: JanSetuColors.crimsonAlert,
      ),
      scaffoldBackgroundColor: JanSetuColors.lightBg,
      cardTheme: CardThemeData(
        color: JanSetuColors.lightSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: JanSetuColors.lightBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: JanSetuColors.lightSurface,
        foregroundColor: JanSetuColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }

  // Dark Theme Configuration (Executive Command Centers)
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: JanSetuColors.electricBlue,
        brightness: Brightness.dark,
        primary: JanSetuColors.electricBlue,
        onPrimary: Colors.white,
        secondary: JanSetuColors.emeraldGreen,
        surface: JanSetuColors.darkBg,
        error: JanSetuColors.crimsonAlert,
      ),
      scaffoldBackgroundColor: JanSetuColors.darkBg,
      cardTheme: CardThemeData(
        color: JanSetuColors.darkSurface,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMedium),
          side: const BorderSide(color: JanSetuColors.darkBorder, width: 1),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: JanSetuColors.darkSurface,
        foregroundColor: JanSetuColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
      ),
    );
  }
}
