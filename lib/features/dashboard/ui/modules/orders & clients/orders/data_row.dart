import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/order_class.dart';

class OrdersDataRow extends StatelessWidget {
  const OrdersDataRow({super.key});

  static List<DataRow> getRows(BuildContext context) {
    return testOrders
        .map(
          (order) => DataRow(
            color: MaterialStateProperty.all(
              Theme.of(context).scaffoldBackgroundColor,
            ),
            cells: [
              DataCell(
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Text(
                    order.clientName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                  ),
                ),
              ),
              DataCell(
                Text(
                  order.orderId,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                ),
              ),
              DataCell(
                Text(
                  '${order.totalPrice.toStringAsFixed(2)} DA',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                ),
              ),
              DataCell(order.buildStatusBadge(context)),
              DataCell(_orderActions(context)),
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
          width: 25.sp,
          height: 25.sp,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Not used for DataTable
  }
}
