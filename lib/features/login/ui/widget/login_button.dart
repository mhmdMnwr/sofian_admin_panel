import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      width: 400,

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
    );
  }
}
