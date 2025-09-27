import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/data_row.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/header_row.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
      child: Container(
        constraints: BoxConstraints(maxHeight: 800.h, minHeight: 300.h),

        padding: EdgeInsets.only(top: 26.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            verticalSpace(24),

            Expanded(child: _buildOrdersTable(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Text(
        AppLocalizations.of(context)!.recent_orders,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
    );
  }

  Widget _buildOrdersTable(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: Column(
          children: [
            // Fixed Header Row
            const HeaderRow(),
            // Scrollable Data Rows
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: OrdersDataRow.buildDataRows(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
