import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/login_button.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/login_form.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/logo.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/welcomeback_message.dart';

class LoginContainer extends StatelessWidget {
  const LoginContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 820.h,
        width: 500.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10.r,
              offset: Offset(0, 5.h),
            ),
          ],
        ),
        child: Column(
          children: [Logo(), WelcomeBackMessage(), LoginForm(), LoginButton()],
        ),
      ),
    );
  }
}
