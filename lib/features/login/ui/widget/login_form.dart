import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/core/widgets/login_text_form_field.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 70.w, vertical: 35.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Username Field
            LoginTextFormField(
              controller: _emailController,
              hintText: AppLocalizations.of(context)!.username,

              prefixIcon: _myImage(IconsManager.person),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enter_username;
                }
                return null;
              },
            ),
            verticalSpace(60),

            // Password Field
            LoginTextFormField(
              controller: _passwordController,
              hintText: AppLocalizations.of(context)!.password,

              isObscureText: _obscurePassword,
              prefixIcon: _myImage(IconsManager.password),
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey.shade600,
                  size: 25.sp,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enter_password;
                }

                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _myImage(String path) {
    return Image.asset(path, width: 18.sp, height: 18.sp, fit: BoxFit.contain);
  }
}
