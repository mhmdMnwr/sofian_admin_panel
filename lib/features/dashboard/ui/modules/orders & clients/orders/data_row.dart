import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/order_class.dart';

class OrdersDataRow extends StatelessWidget {
  const OrdersDataRow({super.key});

  static List<DataRow> getRows(BuildContext context) {
    // Calculate the width for each expanded column
    // Total available width minus the fixed first column (200.w) divided by 4 remaining columns
    final double screenWidth = MediaQuery.of(context).size.width;
    final double availableWidth =
        screenWidth - 200.w - 40.w; // 40.w for padding/margins
    final double expandedColumnWidth = availableWidth / 4;

    return testOrders
        .map(
          (order) => DataRow(
            color: WidgetStateProperty.all(
              Theme.of(context).scaffoldBackgroundColor,
            ),
            cells: [
              DataCell(
                Container(
                  width: 200.w, // Fixed width matching header
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    order.clientName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis, // Handle long names
                    maxLines: 3,
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: expandedColumnWidth,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    order.orderId,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: expandedColumnWidth,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '${order.totalPrice.toStringAsFixed(2)} DA',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                  ),
                ),
              ),
              DataCell(
                Container(
                  width: expandedColumnWidth,
                  alignment: Alignment.centerLeft,
                  child: order.buildStatusBadge(context),
                ),
              ),
              DataCell(
                Container(
                  width: expandedColumnWidth,
                  alignment: Alignment.centerLeft,
                  child: _orderActions(context),
                ),
              ),
            ],
          ),
        )
        .toList();
  }

  static Widget _orderActions(BuildContext context) {
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

  static Widget _buildAction(String path, BuildContext context) {
    return InkWell(
      onTap: () {
        // Handle action
      },
      child: Container(
        padding: EdgeInsets.all(6.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
        child: Image.asset(
          path,
          color: Theme.of(context).iconTheme.color,
          width: 36.sp,
          height: 36.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Not used for DataTable
  }
}
