import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/login_container.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/login_background.dart';

class BreakPoints {
  static const double phoneSize = 650;
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    bool isPhone = width < BreakPoints.phoneSize;

    return Scaffold(
      body: isPhone
          ? const LoginContainer()
          : Stack(children: [ColorfulBackground(), LoginContainer()]),
    );
  }
}
