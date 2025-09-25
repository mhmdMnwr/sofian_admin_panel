import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/line_chart.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/stats/pi_chart.dart';

class StatsRow extends StatelessWidget {
  const StatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Line Chart
        Expanded(child: const LineChartWidget()),
        horizontalSpace(10),
        Expanded(child: const TopSellingProductsPieChart()),
      ],
    );
  }
}
