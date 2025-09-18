import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/font_weight.dart';

class TextStyles {
  static final font20formblackMedium = TextStyle(
    fontSize: 20.sp,
    color: ColorsManager.formBlack,
    fontWeight: FontWeightHelper.medium,
  );

  static final font36blackMedium = TextStyle(
    fontSize: 36.sp,
    color: Colors.black,
    fontWeight: FontWeightHelper.medium,
  );
}
