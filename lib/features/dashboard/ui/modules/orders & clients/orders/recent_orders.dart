import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/widgets/generic_table.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_model.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

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
      onDelete: (int index) {},
      onEdit: (int index) {},
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
}
