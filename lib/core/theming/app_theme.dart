import 'package:flutter/material.dart';
import 'app_colors.dart';
import '../styles.dart';

class ThemeManager {
  //! this is the light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: ColorsManager.sideBarBackgroundLight,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: const TextTheme(
      labelLarge: TextStyles.font20whiteMedium,
    ),

    

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.secondary,
    ),
  );

  //! this is the dark theme

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: ColorsManager.sideBarBackgroundDark,
    scaffoldBackgroundColor: ColorsManager.backgroundDark,
    textTheme: const TextTheme(
      labelLarge: TextStyles.font20blackMedium,
    ),

    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: ColorsManager.secondaryDark),
  );
}
