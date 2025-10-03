import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class TableLogic {
  // Constants
  static const int maxColumnsBeforeScroll = 4;

  // Prepare headers by adding Actions column if not present
  static List<String> prepareHeaders(
    BuildContext context,
    List<String> headers,
  ) {
    List<String> finalHeaders = List.from(headers);
    if (!finalHeaders.contains('Actions')) {
      finalHeaders.add(AppLocalizations.of(context)!.action);
    }
    return finalHeaders;
  }

  // Prepare flex values by adding default flex for Actions column
  static List<int> prepareFlexValues(List<int> flexValues, int headersLength) {
    List<int> finalFlexValues = List.from(flexValues);
    if (finalFlexValues.length < headersLength) {
      finalFlexValues.add(2); // Default flex for Actions column
    }
    return finalFlexValues;
  }

  // Check if horizontal scrolling is needed
  static bool needsHorizontalScrolling(int headersCount) {
    return headersCount > maxColumnsBeforeScroll;
  }

  // Calculate fixed column width for scrollable tables
  static double calculateFixedColumnWidth({
    required double screenWidth,
    required double minColumnWidth,
    required double maxColumnWidth,
    required double availableWidth,
  }) {
    double calculatedWidth = availableWidth / maxColumnsBeforeScroll;
    return calculatedWidth.clamp(minColumnWidth, maxColumnWidth);
  }

  // Calculate total table width for scrollable tables
  static double calculateTotalTableWidth({
    required int headersCount,
    required double fixedColumnWidth,
  }) {
    return headersCount * fixedColumnWidth;
  }

  // Check if content fits within available height
  static bool contentFitsVertically({
    required int dataLength,
    required double rowHeight,
    required double maxAvailableHeight,
  }) {
    double totalRowsHeight = dataLength * rowHeight;
    return totalRowsHeight <= maxAvailableHeight;
  }

  // Generate table cells from raw data
  static List<Widget> generateTableCells({
    required List<dynamic> rowData,
    required int rowIndex,
    required BuildContext context,
    required Map<int, Widget Function(dynamic)>? customBuilders,
    required Widget Function(dynamic, BuildContext?) defaultCellBuilder,
    required Widget Function(int, BuildContext) actionButtonsBuilder,
  }) {
    List<Widget> cells = [];

    // Build cells for actual data columns
    for (int i = 0; i < rowData.length; i++) {
      if (customBuilders != null && customBuilders.containsKey(i)) {
        // Use custom builder if provided
        cells.add(customBuilders[i]!(rowData[i]));
      } else {
        // Default: convert to text
        cells.add(defaultCellBuilder(rowData[i], context));
      }
    }

    // Add actions column
    cells.add(actionButtonsBuilder(rowIndex, context));

    return cells;
  }

  // Get text alignment based on RTL
  static TextAlign getTextAlignment(bool isRTL) {
    return isRTL ? TextAlign.right : TextAlign.left;
  }

  // Get widget alignment based on RTL
  static Alignment getAlignment(bool isRTL) {
    return isRTL ? Alignment.centerRight : Alignment.centerLeft;
  }

  // Get main axis alignment for action buttons based on RTL
  static MainAxisAlignment getActionAlignment(bool isRTL) {
    return isRTL ? MainAxisAlignment.end : MainAxisAlignment.start;
  }

  // Check if direction is RTL
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }
}
