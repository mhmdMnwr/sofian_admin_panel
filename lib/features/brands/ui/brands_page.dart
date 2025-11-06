import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/brands/ui/widget/brand_list.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class BrandsPage extends StatelessWidget {
  const BrandsPage({super.key});

  @override
  Widget build(BuildContext context) {
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
                      PageTitle(
                        pageName: AppLocalizations.of(
                          context,
                        )!.brands_management,
                      ),
                      Spacer(),
                      AppButton(text: AppLocalizations.of(context)!.add_brand),
                    ],
                  );
                } else {
                  // Narrow screen: Title and button stacked vertically
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageTitle(
                        pageName: AppLocalizations.of(
                          context,
                        )!.brands_management,
                      ),
                      verticalSpace(16),
                      AppButton(text: AppLocalizations.of(context)!.add_brand),
                    ],
                  );
                }
              },
            ),
            BrandsList(),
          ],
        ),
      ),
    );
  }
}
