import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF007BFF); // Blue
  static const Color onPrimary = Colors.white;
  static const Color secondary = Color(0xFF6C757D); // Gray
  static const Color tertiary = Color(0xFF17A2B8); // Teal
  static const Color surface = Color(0xFFF8F9FA); // Off-white
  static const Color backgroundLight = Color(0xFFE6F7FF); // Light blue
  static const Color backgroundDark = Colors.black; // Dark gray
  static const Color error = Color(0xFFDC3545); // Red
  static const Color success = Color(0xFF28A745); // Green
  static const Color warning = Color(0xFFFFC107); // Amber
  static const Color info = Color(0xFF17A2B8); // Teal
}

class AppTextStyles {
  static const TextStyle displayLarge = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: 'RobotoCondensed',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: Colors.black,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: Color(0xFF333333), // Dark gray
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Color(0xFF6C757D), // Gray
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: 'OpenSans',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Color(0xFF6C757D), // Gray
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: 'Montserrat',
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: Colors.black,
  );
}

class AppButtonStyles {
  static ElevatedButtonThemeData elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: AppColors.onPrimary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
  );

  static OutlinedButtonThemeData outlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: Colors.black,
      backgroundColor: Colors.transparent,
      side: const BorderSide(color: Colors.black, width: 1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      textStyle: const TextStyle(
        fontFamily: 'RobotoCondensed',
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class AppInputDecorations {
  static const InputDecorationTheme inputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Color(0xFF333333),
    ),
    hintStyle: TextStyle(
      fontFamily: 'OpenSans',
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Color(0xFF6C757D),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Color(0xFF6C757D)), // Gray
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: AppColors.error),
    ),
  );
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: Colors.white,
      error: AppColors.error,
    ),
    scaffoldBackgroundColor: Colors.black,
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge,
      displayMedium: AppTextStyles.displayMedium,
      titleLarge: AppTextStyles.titleLarge,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,
      labelLarge: AppTextStyles.labelLarge,
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFF444444), // Gray
      size: 24,
    ),
    elevatedButtonTheme: AppButtonStyles.elevatedButtonTheme,
    outlinedButtonTheme: AppButtonStyles.outlinedButtonTheme,
    inputDecorationTheme: AppInputDecorations.inputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.secondary,
      tertiary: AppColors.tertiary,
      surface: Color(0xFF343A40),
      error: AppColors.error,
    ),
    textTheme: TextTheme(
      displayLarge: AppTextStyles.displayLarge.copyWith(color: Colors.white),
      displayMedium: AppTextStyles.displayMedium.copyWith(color: Colors.white),
      titleLarge: AppTextStyles.titleLarge.copyWith(color: Colors.white),
      bodyLarge: AppTextStyles.bodyLarge.copyWith(color: Color(0xFFE0E0E0)), // Light gray
      bodyMedium: AppTextStyles.bodyMedium.copyWith(color: Color(0xFFE0E0E0)), // Light gray
      bodySmall: AppTextStyles.bodySmall.copyWith(color: Color(0xFFE0E0E0)), // Light gray
      labelLarge: AppTextStyles.labelLarge.copyWith(color: Colors.white),
    ),
    iconTheme: const IconThemeData(
      color: Colors.white,
      size: 24,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.white, width: 1),
      ),
    ),
    inputDecorationTheme: AppInputDecorations.inputDecorationTheme.copyWith(
      labelStyle: AppInputDecorations.inputDecorationTheme.labelStyle!.copyWith(color: Color(0xFFE0E0E0)), // Light gray
      hintStyle: AppInputDecorations.inputDecorationTheme.hintStyle!.copyWith(color: Color(0xFFE0E0E0)), // Light gray
    ),
  );

  static ThemeData getThemeData(bool isDarkMode) {
    return isDarkMode ? darkTheme : lightTheme;
  }
}