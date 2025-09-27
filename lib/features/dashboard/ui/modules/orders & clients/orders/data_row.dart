import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/order_class.dart';

class OrdersDataRow extends StatelessWidget {
  const OrdersDataRow({super.key});

  static List<Widget> buildDataRows(BuildContext context) {
    return testOrders
        .map(
          (order) => _buildDataRow(context, order, testOrders.indexOf(order)),
        )
        .toList();
  }

  static Widget _buildDataRow(BuildContext context, order, index) {
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
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.centerLeft,
              child: Text(
                order.clientName,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13),
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                order.orderId,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                '${order.totalPrice.toStringAsFixed(2)} DA',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 13),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: order.buildStatusBadge(context),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: _orderActions(context),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _orderActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildAction(IconsManager.preview, context),
        verticalSpace(4),
        _buildAction(IconsManager.edit, context),
        verticalSpace(4),
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
        padding: EdgeInsets.all(4.w), // Reduced padding to make buttons smaller
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4.r)),
        child: Image.asset(
          path,
          color: Theme.of(context).iconTheme.color,
          width: 25, // Reduced size
          height: 25, // Reduced size
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.shrink();
  }
}
