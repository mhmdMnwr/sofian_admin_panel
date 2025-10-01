import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class GenericTable extends StatelessWidget {
  final List<String> headers;
  final List<List<dynamic>> data; // Raw data for each row
  final List<int> flexValues;
  final bool showEdit;
  final bool showDelete;
  final bool showView;
  final Function(int)? onEdit;
  final Function(int)? onDelete;
  final Function(int)? onView;
  final Widget child;
  final Map<int, Widget Function(dynamic)>?
  customBuilders; // Custom builders for specific columns

  const GenericTable({
    super.key,
    required this.headers,
    required this.data,
    required this.flexValues,
    this.showEdit = true,
    this.showDelete = true,
    this.showView = true,
    this.onEdit,
    this.onDelete,
    this.onView,
    this.customBuilders,
    this.child = const SizedBox.shrink(),
  });

  @override
  Widget build(BuildContext context) {
    List<String> finalHeaders = List.from(headers);
    if (!finalHeaders.contains('Actions')) {
      finalHeaders.add(AppLocalizations.of(context)!.action);
    }

    List<int> finalFlexValues = List.from(flexValues);
    if (finalFlexValues.length < finalHeaders.length) {
      finalFlexValues.add(2); // Default flex for Actions column
    }

    return Padding(
      padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              child,
              _buildHeader(context, finalHeaders, finalFlexValues),
              // Calculate if we need scrolling
              _buildTableBody(context, finalFlexValues),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableBody(BuildContext context, List<int> finalFlexValues) {
    // Calculate heights
    double screenHeight = MediaQuery.of(context).size.height;
    double rowHeight = 70.h;
    double totalRowsHeight = data.length * rowHeight;
    double paddingAndOtherElements =
        200.h; // Reserve space for padding, app bar, etc.
    double maxAvailableHeight = screenHeight - paddingAndOtherElements;

    if (totalRowsHeight <= maxAvailableHeight) {
      // Content fits within available space - no scrolling needed
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: data.asMap().entries.map((entry) {
          int index = entry.key;
          List<dynamic> rowData = entry.value;
          return _buildRow(context, rowData, index, finalFlexValues);
        }).toList(),
      );
    } else {
      // Content exceeds available space - use scrolling
      return SizedBox(
        height: maxAvailableHeight - 130.h,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: data.asMap().entries.map((entry) {
              int index = entry.key;
              List<dynamic> rowData = entry.value;
              return _buildRow(context, rowData, index, finalFlexValues);
            }).toList(),
          ),
        ),
      );
    }
  }

  Widget _buildHeader(
    BuildContext context,
    List<String> finalHeaders,
    List<int> finalFlexValues,
  ) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      child: Row(
        children: List.generate(finalHeaders.length, (index) {
          return Expanded(
            flex: finalFlexValues[index],
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                finalHeaders[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    List<dynamic> rowData,
    int index,
    List<int> finalFlexValues,
  ) {
    // Generate widgets from raw data
    List<Widget> cells = [];

    // Build cells for actual data columns
    for (int i = 0; i < rowData.length; i++) {
      if (customBuilders != null && customBuilders!.containsKey(i)) {
        // Use custom builder if provided
        cells.add(customBuilders![i]!(rowData[i]));
      } else {
        // Default: convert to text
        cells.add(_buildDefaultCell(rowData[i], context));
      }
    }

    // Add actions column
    cells.add(_buildActionButtons(index, context));

    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: index.isEven
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      child: Row(
        children: List.generate(cells.length, (cellIndex) {
          bool isRTL = Directionality.of(context) == TextDirection.rtl;
          return Expanded(
            flex: finalFlexValues[cellIndex],
            child: Container(
              padding: EdgeInsets.only(left: 20.w, right: 5.w),
              alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
              child: DefaultTextStyle(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 15),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                child: cells[cellIndex],
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildDefaultCell(dynamic value, [BuildContext? context]) {
    if (value is Widget) {
      return value;
    } else if (value is IconData) {
      return Icon(value);
    } else {
      bool isRTL =
          context != null && Directionality.of(context) == TextDirection.rtl;
      return Text(
        value?.toString() ?? '',
        textAlign: isRTL ? TextAlign.right : TextAlign.left,
      );
    }
  }

  _buildAction(String imagePath, int rowIndex, BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      icon: Image.asset(
        imagePath,
        color: Theme.of(context).iconTheme.color,
        width: 26,
        height: 26,
      ),
      onPressed: () => onView!(rowIndex),
    );
  }

  Widget _buildActionButtons(int rowIndex, context) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;
    List<Widget> actions = [];

    if (showView && onView != null) {
      actions.add(_buildAction(IconsManager.preview, rowIndex, context));
    }

    if (showEdit && onEdit != null) {
      actions.add(_buildAction(IconsManager.edit, rowIndex, context));
    }

    if (showDelete && onDelete != null) {
      actions.add(_buildAction(IconsManager.delete, rowIndex, context));
    }

    // Reverse actions order for RTL
    if (isRTL) {
      actions = actions.reversed.toList();
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: isRTL
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: actions.map((action) {
        int actionIndex = actions.indexOf(action);
        return actionIndex > 0
            ? Row(children: [horizontalSpace(8.w), action])
            : action;
      }).toList(),
    );
  }
}
