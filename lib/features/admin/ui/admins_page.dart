import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/features/admin/ui/widget/admin_grid.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class AdminsPage extends StatelessWidget {
  const AdminsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.pageHorizontalPadding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen =
                    MediaQuery.of(context).size.width >=
                    AppConstants.phoneBreakPoint;

                if (isWideScreen) {
                  // Wide screen: Title and button in a row
                  return Row(
                    children: [
                      PageTitle(pageName: localizations.admins_management),
                      Spacer(),
                      AddButton(text: localizations.add_admin),
                    ],
                  );
                } else {
                  // Narrow screen: Title and button stacked vertically
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageTitle(pageName: localizations.admins_management),
                      verticalSpace(16),
                      AddButton(text: localizations.add_admin),
                    ],
                  );
                }
              },
            ),
            AdminGrid(admins: sampleAdmins),
          ],
        ),
      ),
    );
  }
}
