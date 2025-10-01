import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/clients/active_clients.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/recent_orders.dart';

class RecentOrdersAndActiveClients extends StatelessWidget {
  const RecentOrdersAndActiveClients({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isPhone = width < AppConstants.phoneBreakPoint;
    return isPhone ? _buildStatsColumn(context) : _buildStatsRow(context);
  }

  _buildStatsColumn(BuildContext context) {
    return Column(
      children: [const RecentOrders(), verticalSpace(20), ActiveClients()],
    );
  }

  _buildStatsRow(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 3, child: const RecentOrders()),
        horizontalSpace(20),
        Expanded(flex: 1, child: ActiveClients()),
      ],
    );
  }
}
