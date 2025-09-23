import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 40.w, right: 40.w, top: 90.h),
      child: InkWell(
        onTap: () {
          context.go('/orders');
        },
        child: Container(
          height: 80.h,

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: ColorsManager.mainBlue,
          ),
          child: Center(
            child: Text(
              AppLocalizations.of(context)!.login,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
