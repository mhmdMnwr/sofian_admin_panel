import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/products/ui/widget/add_product.dart';
import 'package:sofian_admin_panel/features/products/ui/widget/product_list.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: AppConstants.pageHorizontalPadding,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                final isWideScreen =
                    MediaQuery.of(context).size.width >=
                    AppConstants.phoneBreakPoint;

                if (isWideScreen) {
                  return Row(
                    children: [
                      PageTitle(
                        pageName: AppLocalizations.of(
                          context,
                        )!.products_management,
                      ),
                      Spacer(),
                      AppButton(
                        text: AppLocalizations.of(context)!.add_product,
                        onTap: () =>
                            showAddProductDialog(context, isEdit: false),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      PageTitle(
                        pageName: AppLocalizations.of(
                          context,
                        )!.products_management,
                      ),
                      verticalSpace(16),
                      AppButton(
                        text: AppLocalizations.of(context)!.add_product,
                      ),
                    ],
                  );
                }
              },
            ),
            ProductList(),
          ],
        ),
      ),
    );
  }
}
