import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/categories/ui/widget/add_edit_categorie_pop_up.dart';
import 'package:sofian_admin_panel/features/categories/ui/widget/categorie_list.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

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
                        )!.categories_management,
                      ),
                      Spacer(),
                      AppButton(
                        text: AppLocalizations.of(context)!.add_category,
                        onTap: () => showAddCategoryDialog(context),
                      ),
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
                        )!.categories_management,
                      ),
                      verticalSpace(16),
                      AppButton(
                        text: AppLocalizations.of(context)!.add_category,
                        onTap: () => showAddCategoryDialog(context),
                      ),
                    ],
                  );
                }
              },
            ),
            CategorieList(),
          ],
        ),
      ),
    );
  }
}
