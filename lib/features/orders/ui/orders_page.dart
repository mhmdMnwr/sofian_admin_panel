import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/orders/ui/widget/orders_list.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

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
            Row(
              children: [
                PageTitle(
                  pageName: AppLocalizations.of(context)!.order_management,
                ),
              ],
            ),

            OrdersList(),
          ],
        ),
      ),
    );
  }
}
