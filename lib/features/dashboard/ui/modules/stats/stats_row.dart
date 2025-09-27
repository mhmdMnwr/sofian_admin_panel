import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/line%20chart/line_chart.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/pie%20chart/pi_chart.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool isPhone = width < AppConstants.phoneBreakPoint;
    return isPhone ? _buildStatsColumn(context) : _buildStatsRow(context);
  }

  _buildStatsRow(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 55, child: LineChartWidget()),
        horizontalSpace(10),
        Expanded(flex: 45, child: const TopSellingProductsPieChart()),
      ],
    );
  }

  _buildStatsColumn(BuildContext context) {
    return Column(
      children: [
        LineChartWidget(),
        verticalSpace(20),
        TopSellingProductsPieChart(),
      ],
    );
  }
}
