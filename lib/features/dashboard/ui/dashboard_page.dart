import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/widgets/page_title.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/overview%20stats/overview_stats.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/recent_orders_and_active_clients.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/stats_row.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: ListView(
        children: [
          PageTitle(pageName: AppLocalizations.of(context)!.dashboard_overview),
          OverviewStats(),
          StatsRow(),
          RecentOrdersAndActiveClients(),
        ],
      ),
    );
  }
}
