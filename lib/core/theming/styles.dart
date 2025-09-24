import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/font_weight.dart';

class TextStyles {
  static final font20fromblackMedium = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.sp,
    color: ColorsManager.text,
    fontWeight: FontWeightHelper.medium,
  );

  static final font23blackBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 23.sp,
    color: ColorsManager.text,
    fontWeight: FontWeightHelper.bold,
  );

  static final font23whiteBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 23.sp,
    color: ColorsManager.textDark,
    fontWeight: FontWeightHelper.bold,
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
  static final font21mainBlueExtraBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 21.sp,
    color: ColorsManager.mainBlue,
    fontWeight: FontWeightHelper.extraBold,
  );
  static final font21mainPurpleExtraBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 21.sp,
    color: ColorsManager.mainPurple,
    fontWeight: FontWeightHelper.extraBold,
  );

  static final font25mainBlueExtraBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 25.sp,
    color: ColorsManager.mainBlue,
    fontWeight: FontWeightHelper.extraBold,
  );
  static final font30blackExtraBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30.sp,
    color: Colors.black,
    fontWeight: FontWeightHelper.extraBold,
  );
  static final font30whiteExtraBold = TextStyle(
    fontFamily: 'Inter',
    fontSize: 30.sp,
    color: Colors.white,
    fontWeight: FontWeightHelper.extraBold,
  );

  static final font22blackMedium = TextStyle(
    fontFamily: "Inter",
    fontSize: 22.sp,
    color: Colors.black,
    fontWeight: FontWeightHelper.medium,
  );

  static final font16GreenExtraBold = TextStyle(
    fontFamily: "Inter",
    fontSize: 16.sp,
    color: ColorsManager.growthGreen,
    fontWeight: FontWeightHelper.extraBold,
  );
  static final font16RedExtraBold = TextStyle(
    fontFamily: "Inter",
    fontSize: 16.sp,
    color: ColorsManager.lossRed,
    fontWeight: FontWeightHelper.extraBold,
  );

  static final hint = TextStyle(
    fontFamily: 'Inter',
    fontSize: 20.sp,
    color: Colors.black45,
    fontWeight: FontWeightHelper.light,
  );
}
