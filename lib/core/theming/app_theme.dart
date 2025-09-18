import 'package:flutter/material.dart';
import 'app_colors.dart';

class ThemeManager {
  //! this is the light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsManager.primary,
    scaffoldBackgroundColor: ColorsManager.background,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 28),
      displaySmall: TextStyle(fontSize: 24),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
    ),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.secondary,
    ),
  );

  //! this is the dark theme

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsManager.primaryDark,
    scaffoldBackgroundColor: ColorsManager.backgroundDark,
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(fontSize: 28),
      displaySmall: TextStyle(fontSize: 24),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      titleLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      bodyLarge: TextStyle(fontSize: 16),
      bodyMedium: TextStyle(fontSize: 14),
      bodySmall: TextStyle(fontSize: 12),
    ),

    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: ColorsManager.secondaryDark),
  );
}
