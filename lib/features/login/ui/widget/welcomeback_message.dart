import 'package:flutter/widgets.dart';
import 'package:sofian_admin_panel/core/theming/styles.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class WelcomeBackMessage extends StatelessWidget {
  const WelcomeBackMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        AppLocalizations.of(context)!.welcome,
        style: TextStyles.font36blackMedium,
      ),
    );
  }
}
