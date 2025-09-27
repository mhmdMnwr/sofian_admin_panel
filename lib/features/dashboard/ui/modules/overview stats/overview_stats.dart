import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/overview%20stats/stats_container.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class OverviewStats extends StatelessWidget {
  const OverviewStats({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isPhone = width < AppConstants.phoneBreakPoint;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0.h),
      child: isPhone
          ? _buildPhoneStatsColumn(context)
          : _buildStatsRow(context),
    );
  }

  _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatsContainer(
            title: AppLocalizations.of(context)!.revenue,

            value: 1234555.67,
            icon: IconsManager.revenue,
            isLoss: true,
            pourcentage: 2.6,
          ),
        ),
        horizontalSpace(22),
        Expanded(
          child: StatsContainer(
            title: AppLocalizations.of(context)!.orders,
            value: 8901,
            icon: IconsManager.completedOrders,
            isLoss: false,
            pourcentage: 3,
          ),
        ),
        horizontalSpace(22),
        Expanded(
          child: StatsContainer(
            title: AppLocalizations.of(context)!.clients,
            value: 456,
            icon: IconsManager.clients,
            isLoss: false,
            pourcentage: 2.6,
          ),
        ),
      ],
    );
  }

  _buildPhoneStatsColumn(BuildContext context) {
    return Column(
      children: [
        StatsContainer(
          width: double.infinity,
          title: AppLocalizations.of(context)!.revenue,
          value: 1234555.67,
          icon: IconsManager.revenue,
          isLoss: true,
          pourcentage: 2.6,
        ),
        verticalSpace(16),
        StatsContainer(
          width: double.infinity,
          title: AppLocalizations.of(context)!.orders,
          value: 8901,
          icon: IconsManager.completedOrders,
          isLoss: false,
          pourcentage: 3,
        ),

        verticalSpace(16),
        StatsContainer(
          width: double.infinity,
          title: AppLocalizations.of(context)!.clients,
          value: 456,
          icon: IconsManager.clients,
          isLoss: false,
          pourcentage: 2.6,
        ),
      ],
    );
  }
}
