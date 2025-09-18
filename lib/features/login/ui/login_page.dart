import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/login/ui/widget/login_container.dart';
import 'package:sofian_admin_panel/features/login/ui/widget/login_packground.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [ColorfulBackground(), LoginContainer()]),
    );
  }
}
