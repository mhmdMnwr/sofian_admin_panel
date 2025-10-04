import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/categories/ui/widget/categorie_list.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.pageHorizontalPadding,
        ),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen = MediaQuery.of(context).size.width >= 600;

                if (isWideScreen) {
                  // Wide screen: Title and FAB in a row
                  return Row(
                    children: [
                      PageTitle(
                        pageName: AppLocalizations.of(
                          context,
                        )!.categories_management,
                      ),
                      Spacer(),
                      FloatingActionButton.extended(
                        onPressed: () {
                          // TODO: Add category functionality
                        },
                        icon: Icon(Icons.add),
                        label: Text(AppLocalizations.of(context)!.add_category),
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                      ),
                    ],
                  );
                } else {
                  // Narrow screen: Only title, FAB will be positioned at bottom-right
                  return Row(
                    children: [
                      PageTitle(
                        pageName: AppLocalizations.of(
                          context,
                        )!.categories_management,
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
      floatingActionButton: MediaQuery.of(context).size.width < 600
          ? FloatingActionButton(
              onPressed: () {
                // TODO: Add category functionality
              },
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }
}
