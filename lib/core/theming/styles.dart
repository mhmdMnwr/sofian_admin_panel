import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/font_weight.dart';

class TextStyles {
  static final font20formblackMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.sp,
    color: ColorsManager.formBlack,
    fontWeight: FontWeightHelper.medium,
  );

  static final font32blackMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 32.sp,
    color: Colors.black,
    fontWeight: FontWeightHelper.medium,
  );

  static final font26blackbold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 26.sp,
    color: Colors.black,
    fontWeight: FontWeightHelper.bold,
  );

  static final font26whitebold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 26.sp,
    color: Colors.white,
    fontWeight: FontWeightHelper.bold,
  );
  static final font26mainBlueBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 26.sp,
    color: ColorsManager.mainBlue,
    fontWeight: FontWeightHelper.extraBold,
  );

  static final hint = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.sp,
    color: Colors.black45,
    fontWeight: FontWeightHelper.light,
  );
}
