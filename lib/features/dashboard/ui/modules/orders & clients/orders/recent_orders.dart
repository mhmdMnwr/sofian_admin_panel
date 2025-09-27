import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/header_row.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/order_class.dart';
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
          fontSize: 20.sp,
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
                child: Column(children: _buildDataRows(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDataRows(BuildContext context) {
    return testOrders
        .map(
          (order) => _buildDataRow(context, order, testOrders.indexOf(order)),
        )
        .toList();
  }

  Widget _buildDataRow(BuildContext context, order, index) {
    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: index.isEven
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            alignment: Alignment.centerLeft,
            child: Text(
              order.clientName,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              overflow: TextOverflow.ellipsis,
              maxLines: 3,
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                order.orderId,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${order.totalPrice.toStringAsFixed(2)} DA',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: order.buildStatusBadge(context),
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: _orderActions(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAction(IconsManager.preview, context),
        SizedBox(width: 4.w),
        _buildAction(IconsManager.edit, context),
        SizedBox(width: 4.w),
        _buildAction(IconsManager.delete, context),
      ],
    );
  }

  Widget _buildAction(String path, BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle action
      },
      child: Container(
        padding: EdgeInsets.all(4.w), // Reduced padding to make buttons smaller
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
        child: Image.asset(
          path,
          color: Theme.of(context).iconTheme.color,
          width: 20.sp, // Reduced size
          height: 20.sp, // Reduced size
        ),
      ),
    );
  }
}
