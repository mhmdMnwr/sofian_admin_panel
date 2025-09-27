import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/data/chart_data_table.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class LineChartHeader extends StatefulWidget {
  const LineChartHeader({super.key});

  @override
  State<LineChartHeader> createState() => _LineChartHeaderState();
}

class _LineChartHeaderState extends State<LineChartHeader> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildTabButton(
          context,
          ChartType.revenue,
          AppLocalizations.of(context)!.revenue,
        ),
        horizontalSpace(8),
        _buildTabButton(
          context,
          ChartType.orders,
          AppLocalizations.of(context)!.orders,
        ),
        horizontalSpace(8),
        _buildTabButton(
          context,
          ChartType.clients,
          AppLocalizations.of(context)!.clients,
        ),
        const Spacer(),
        _buildYearDropdown(),
      ],
    );
  }

  Widget _buildTabButton(BuildContext context, ChartType type, String title) {
    final isSelected = selectedChart == type;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedChart = type;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? ColorsManager.mainBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
