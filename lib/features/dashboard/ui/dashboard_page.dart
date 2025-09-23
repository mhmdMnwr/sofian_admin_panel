import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/widget/Page_title.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/widget/overview_stats.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/widget/recent_orders_and_active_clients.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/widget/stats_row.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          PageTitle(),
          OverviewStats(),
          StatsRow(),
          RecentOrdersAndActiveClients(),
        ],
      ),
    );
  }
}
