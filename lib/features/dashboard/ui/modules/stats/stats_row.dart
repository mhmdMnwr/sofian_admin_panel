import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/line_chart.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/pi_chart.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Line Chart
        Expanded(flex: 55, child: const LineChartWidget()),
        horizontalSpace(10),
        Expanded(flex: 45, child: const TopSellingProductsPieChart()),
        // const TopSellingProductsPieChart(),
      ],
    );
  }
}
