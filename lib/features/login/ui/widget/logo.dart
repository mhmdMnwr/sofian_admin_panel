import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';

class Logo extends StatelessWidget {
  final double horizontalPadding;
  final double verticalPadding;
  const Logo({
    super.key,
    this.horizontalPadding = 60.0,
    this.verticalPadding = 60.0,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding.w,
        vertical: verticalPadding.h,
      ),
      child: Center(
        child: Image.asset(
          IconsManager.logo,
          width: 300,
          height: 120.h,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
