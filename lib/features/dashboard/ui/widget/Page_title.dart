import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context)!.dashboard_overview,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }
}
