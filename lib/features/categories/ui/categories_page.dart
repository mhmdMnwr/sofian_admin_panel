import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
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
          children: [
            Row(
              children: [
                PageTitle(
                  pageName: AppLocalizations.of(context)!.categories_management,
                ),
                Spacer(),
                AddButton(text: AppLocalizations.of(context)!.add_category),
              ],
            ),
            CategorieList(),
          ],
        ),
      ),
    );
  }
}
