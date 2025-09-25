import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/line_chart.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/pi_chart.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Line Chart
        const LineChartWidget(),
        verticalSpace(20),
        // Pie Chart for Top Selling Products
        // const TopSellingProductsPieChart(),
      ],
    );
  }
}
