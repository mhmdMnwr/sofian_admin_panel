import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/theming/styles.dart';
import 'app_colors.dart';

class ThemeManager {
  //! this is the light theme
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    fontFamily: 'Inter',
    primaryColor: ColorsManager.sideBarBackgroundLight,
    scaffoldBackgroundColor: const Color(0xFFF5F5F5),
    textTheme: TextTheme(bodyMedium: TextStyles.font20blackBold),
    iconTheme: const IconThemeData(color: Colors.black),

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: ColorsManager.secondary,
    ),
  );

  //! this is the dark theme

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    fontFamily: 'Inter',
    primaryColor: ColorsManager.sideBarBackgroundDark,
    scaffoldBackgroundColor: ColorsManager.backgroundDark,
    textTheme: TextTheme(bodyMedium: TextStyles.font20whiteBold),
    iconTheme: const IconThemeData(color: Colors.white),

    colorScheme: ColorScheme.fromSwatch(
      brightness: Brightness.dark,
    ).copyWith(secondary: ColorsManager.secondaryDark),
  );
}
