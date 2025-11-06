import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/extensions.dart';
import 'package:sofian_admin_panel/core/widgets/alert_dialog.dart';
import 'package:sofian_admin_panel/core/widgets/generic_table.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_model.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_details_model.dart';
import 'package:sofian_admin_panel/features/orders/ui/widget/order_details.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;
    return GenericTable(
      headers: [
        AppLocalizations.of(context)!.userName,
        AppLocalizations.of(context)!.order_id,
        AppLocalizations.of(context)!.total_price,
        AppLocalizations.of(context)!.status,
      ],
      data: getTestOrdersList(context),
      onDelete: (int index) {
        _deleteOrder(context);
      },
      onEdit: (int index) {
        showOrderDetailsDialog(context, order: testOrderDetails);
      },
      onView: (int index) {},
      child: _buildTitle(context, isRtl),
    );
  }

  Widget _buildTitle(BuildContext context, bool isRtl) {
    return Align(
      alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(left: 20.w),
        child: Text(
          AppLocalizations.of(context)!.recent_orders,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  _deleteOrder(BuildContext context) {
    return showAppAlertDialog(
      context: context,
      title: AppLocalizations.of(context)!.delete_order,
      content: AppLocalizations.of(
        context,
      )!.are_you_sure_you_want_to_delete_this_order,
      primaryButtonText: AppLocalizations.of(context)!.delete,
      secondaryButtonText: AppLocalizations.of(context)!.cancel,
      onPrimaryButtonTap: () {
        context.pop();
      },
      onSecondaryButtonTap: () {
        context.pop();
      },
    );
  }
}
