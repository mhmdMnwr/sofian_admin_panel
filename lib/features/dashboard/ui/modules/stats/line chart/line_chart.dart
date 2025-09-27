import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/data/chart_data_table.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class LineChartWidget extends StatefulWidget {
  const LineChartWidget({super.key});

  @override
  State<LineChartWidget> createState() => _LineChartWidgetState();
}

class _LineChartWidgetState extends State<LineChartWidget> {
  ChartType selectedChart = ChartType.revenue;
  late String selectedTimePeriod;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Initialize with localized string
    selectedTimePeriod = AppLocalizations.of(context)!.this_year;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool showNumber = width >= 500;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          verticalSpace(45),
          _buildChart(showNumber),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
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
            fontSize: 18,
            color: isSelected
                ? Colors.white
                : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildYearDropdown() {
    final localizations = AppLocalizations.of(context)!;

    // Localized options
    final localizedOptions = [
      localizations.last_7_days,
      localizations.this_year,
      localizations.last_12_months,
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: DropdownButton<String>(
        value: selectedTimePeriod,
        underline: const SizedBox(),
        items: localizedOptions
            .map(
              (String value) => DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(fontSize: 12)),
              ),
            )
            .toList(),
        onChanged: (String? newValue) {
          if (newValue != null) {
            setState(() {
              selectedTimePeriod = newValue;
            });
          }
        },
      ),
    );
  }

  Widget _buildChart(bool showNumber) {
    return SizedBox(
      height: 300.h,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            drawHorizontalLine: true,

            horizontalInterval: _getGridInterval(),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: showNumber,
                reservedSize: 60.w,
                getTitlesWidget: (value, meta) {
                  return Text(
                    _formatYAxisValue(value),
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 30.h,
                interval: 1, // Show labels only at integer intervals
                getTitlesWidget: (value, meta) {
                  // Only show labels for exact data points
                  if (value % 1 != 0) return const Text('');

                  return Text(
                    _getBottomAxisLabel(value.toInt()),
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: _getMaxXValue(),
          minY: 0,
          maxY: _getMaxYValue(),
          lineBarsData: [
            LineChartBarData(
              spots: _getDataForSelectedChart(),
              isCurved: true,
              barWidth: 3,
              isStrokeCapRound: true,
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF4477AC),
                    Theme.of(context).scaffoldBackgroundColor.withOpacity(0.3),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Convert localized string to data key
  String _getDataKey() {
    final localizations = AppLocalizations.of(context)!;
    if (selectedTimePeriod == localizations.last_7_days) return 'Last 7 days';
    if (selectedTimePeriod == localizations.this_year) return 'This year';
    if (selectedTimePeriod == localizations.last_12_months) {
      return 'Last 12 months';
    }
    return 'This year'; // fallback
  }

  String _formatYAxisValue(double value) {
    if (selectedChart == ChartType.revenue) {
      if (value >= 1000) {
        return '${(value / 1000).toInt()}k';
      } else if (value >= 1000000) {
        return '${(value / 1000000).toInt()}M';
      }
      return value.toInt().toString();
    } else {
      return value.toInt().toString();
    }
  }

  List<FlSpot> _getDataForSelectedChart() {
    // Use the data table to get FlSpot data - simulates database call
    return ChartDataTable.getData(selectedChart, _getDataKey());
  }

  double _getMaxYValue() {
    // Use the data table to get dynamic max Y value based on actual data
    return ChartDataTable.getMaxY(selectedChart, _getDataKey());
  }

  double _getGridInterval() {
    // Use the data table to get appropriate grid interval
    return ChartDataTable.getGridInterval(selectedChart, _getDataKey());
  }

  double _getMaxXValue() {
    final dataKey = _getDataKey();
    switch (dataKey) {
      case 'Last 7 days':
        return 6; // 0-6 for 7 days
      case 'This year':
      case 'Last 12 months':
      default:
        return 11; // 0-11 for 12 months
    }
  }

  String _getBottomAxisLabel(int value) {
    final dataKey = _getDataKey();
    switch (dataKey) {
      case 'Last 7 days':
        const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
        return value >= 0 && value < days.length ? days[value] : '';

      case 'This year':
      case 'Last 12 months':
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return value >= 0 && value < months.length ? months[value] : '';

      default:
        return '';
    }
  }
}
