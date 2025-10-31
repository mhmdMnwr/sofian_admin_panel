import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class GenericTable extends StatefulWidget {
  final List<String> headers;
  final List<List<dynamic>> data; // Raw data for each row
  final List<double>? columnWidths; // Optional custom column widths
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
    this.columnWidths,
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
  State<GenericTable> createState() => _GenericTableState();
}

class _GenericTableState extends State<GenericTable> {
  late final ScrollController _horizontalController;
  late final ScrollController _verticalController;

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> finalHeaders = List.from(widget.headers);
    if (!finalHeaders.contains('Actions')) {
      finalHeaders.add(AppLocalizations.of(context)!.action);
    }

    // Prepare column widths - use custom widths if provided, otherwise use default
    List<double> finalColumnWidths = [];
    if (widget.columnWidths != null && widget.columnWidths!.isNotEmpty) {
      finalColumnWidths = List.from(widget.columnWidths!);
      // Add default width for Actions column if not provided
      while (finalColumnWidths.length < finalHeaders.length) {
        finalColumnWidths.add(_getColumnWidth(context));
      }
    } else {
      // Use default responsive widths for all columns
      double defaultWidth = _getColumnWidth(context);
      finalColumnWidths = List.generate(
        finalHeaders.length,
        (index) => defaultWidth,
      );
    }

    // Ensure actions column has a sane minimum width, but still allow it to be small
    final int actionsIndex = finalColumnWidths.length - 1;
    finalColumnWidths[actionsIndex] = math.max(
      finalColumnWidths[actionsIndex],
      90.0,
    );

    // Compute total width for horizontal scroll area
    double totalWidth = finalColumnWidths.fold(0.0, (s, w) => s + w);

    return Padding(
      padding: const EdgeInsets.only(top: 30, bottom: 10),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              widget.child,
              verticalSpace(30),
              // Horizontal scrollbar + scroll area
              Scrollbar(
                controller: _horizontalController,
                thumbVisibility: true,
                thickness: 8,
                radius: const Radius.circular(8),
                child: SingleChildScrollView(
                  controller: _horizontalController,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  child: SizedBox(
                    width: totalWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, finalHeaders, finalColumnWidths),
                        // Table body with vertical scrollbar when needed
                        _buildTableBody(context, finalColumnWidths),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableBody(BuildContext context, List<double> finalColumnWidths) {
    // Calculate heights for responsive design
    double screenHeight = MediaQuery.of(context).size.height;
    double rowHeight = 60; // Fixed height for web
    double totalRowsHeight = widget.data.length * rowHeight;
    double paddingAndOtherElements =
        200; // Reserve space for padding, app bar, etc.
    double maxAvailableHeight = screenHeight - paddingAndOtherElements;

    if (totalRowsHeight <= maxAvailableHeight) {
      // Content fits - no vertical scrolling needed
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: widget.data.asMap().entries.map((entry) {
          int index = entry.key;
          List<dynamic> rowData = entry.value;
          return _buildRow(context, rowData, index, finalColumnWidths);
        }).toList(),
      );
    } else {
      // Need vertical scrolling - wrap with Scrollbar and controller
      double height = math.max(120, maxAvailableHeight - 90);
      return SizedBox(
        height: height,
        child: Scrollbar(
          controller: _verticalController,
          thumbVisibility: true,
          thickness: 8,
          radius: const Radius.circular(8),
          child: SingleChildScrollView(
            controller: _verticalController,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: widget.data.asMap().entries.map((entry) {
                int index = entry.key;
                List<dynamic> rowData = entry.value;
                return _buildRow(context, rowData, index, finalColumnWidths);
              }).toList(),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildHeader(
    BuildContext context,
    List<String> finalHeaders,
    List<double> finalColumnWidths,
  ) {
    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(finalHeaders.length, (index) {
          return SizedBox(
            width: finalColumnWidths[index],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
              child: Text(
                finalHeaders[index],
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                overflow: TextOverflow.ellipsis,
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
    List<double> finalColumnWidths,
  ) {
    // Generate widgets from raw data
    List<Widget> cells = [];

    // Build cells for actual data columns
    for (int i = 0; i < rowData.length; i++) {
      if (widget.customBuilders != null &&
          widget.customBuilders!.containsKey(i)) {
        // Use custom builder if provided
        cells.add(widget.customBuilders![i]!(rowData[i]));
      } else {
        // Default: convert to text
        cells.add(_buildDefaultCell(rowData[i], context));
      }
    }

    // Add actions column (last)
    cells.add(_buildActionButtons(index, context));

    bool isRTL = Directionality.of(context) == TextDirection.rtl;

    return Container(
      height: 60, // Fixed height for web
      decoration: BoxDecoration(
        color: index.isEven
            ? Theme.of(context).scaffoldBackgroundColor
            : Theme.of(context).primaryColor,
        border: const Border(
          bottom: BorderSide(color: Colors.grey, width: 0.8),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(cells.length, (cellIndex) {
          return SizedBox(
            width: finalColumnWidths[cellIndex],
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
              child: DefaultTextStyle(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontSize: 13),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                child: cells[cellIndex],
              ),
            ),
          );
        }),
      ),
    );
  }

  // Get responsive column width
  double _getColumnWidth(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    // Responsive column width with good balance
    if (screenWidth > 1400) return 200;
    if (screenWidth > 1200) return 180;
    if (screenWidth > 900) return 160;
    if (screenWidth > 600) return 140;
    return 120;
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

  // Build a compact action widget that supports either String (asset path) or IconData
  Widget _buildCompactAction(
    dynamic iconOrPath,
    VoidCallback? callback,
    BuildContext ctx,
  ) {
    // Use IconButton with tight constraints so three icons can fit in small widths
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(
        minWidth: 28,
        minHeight: 28,
        maxWidth: 50,
        maxHeight: 36,
      ),
      icon: (() {
        if (iconOrPath is String) {
          return Image.asset(
            iconOrPath,
            width: 20,
            height: 20,
            color: Theme.of(ctx).iconTheme.color,
            fit: BoxFit.contain,
          );
        } else if (iconOrPath is IconData) {
          return Icon(iconOrPath, size: 20);
        } else if (iconOrPath is Widget) {
          return iconOrPath;
        } else {
          // fallback
          return const SizedBox.shrink();
        }
      }()),
      onPressed: callback,
    );
  }

  Widget _buildActionButtons(int rowIndex, BuildContext ctx) {
    bool isRTL = Directionality.of(ctx) == TextDirection.rtl;

    // Determine which action items are present and in what order
    final List<_ActionItem> items = [
      if (widget.showView && widget.onView != null)
        _ActionItem(
          icon: IconsManager.preview,
          onTap: () => widget.onView!(rowIndex),
          labelKey: 'view',
        ),
      if (widget.showEdit && widget.onEdit != null)
        _ActionItem(
          icon: IconsManager.edit,
          onTap: () => widget.onEdit!(rowIndex),
          labelKey: 'edit',
        ),
      if (widget.showDelete && widget.onDelete != null)
        _ActionItem(
          icon: IconsManager.delete,
          onTap: () => widget.onDelete!(rowIndex),
          labelKey: 'delete',
        ),
    ];

    // Reverse for RTL display order
    final displayItems = isRTL ? items.reversed.toList() : items;

    // Popup menu content builder
    List<PopupMenuEntry<int>> buildPopupItems(BuildContext context) {
      final List<PopupMenuEntry<int>> list = [];
      for (int i = 0; i < items.length; i++) {
        final it = items[i];
        final label = _labelForKey(context, it.labelKey);
        list.add(PopupMenuItem(value: i, child: Text(label)));
      }
      return list;
    }

    // LayoutBuilder decides whether to show icons or popup menu depending on available width
    return LayoutBuilder(
      builder: (layoutCtx, constraints) {
        // If the available width is smaller than threshold, show popup menu
        const double threshold = 110.0; // tweak to taste
        if (constraints.maxWidth.isFinite && constraints.maxWidth < threshold) {
          // Show a single overflow popup icon
          return Align(
            alignment: isRTL ? Alignment.centerRight : Alignment.centerLeft,
            child: PopupMenuButton<int>(
              icon: const Icon(Icons.more_vert),
              onSelected: (value) {
                if (value >= 0 && value < items.length) {
                  items[value].onTap?.call();
                }
              },
              itemBuilder: (c) => buildPopupItems(c),
            ),
          );
        } else {
          // Show compact icons in a Row
          return Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: isRTL
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: displayItems.asMap().entries.map((entry) {
              int idx = entry.key;
              _ActionItem itm = entry.value;
              final widgetIcon = _buildCompactAction(itm.icon, itm.onTap, ctx);
              return idx > 0
                  ? Row(children: [const SizedBox(width: 8), widgetIcon])
                  : widgetIcon;
            }).toList(),
          );
        }
      },
    );
  }

  String _labelForKey(BuildContext context, String? key) {
    // Try to map the short keys to localized strings. Adjust keys if your localization uses different names.
    if (key == 'view') return AppLocalizations.of(context)!.view;
    if (key == 'edit') return AppLocalizations.of(context)!.edit;
    if (key == 'delete') return AppLocalizations.of(context)!.delete;
    // fallback
    return AppLocalizations.of(context)!.action;
  }
}

class _ActionItem {
  final dynamic icon; // String path / IconData / Widget
  final VoidCallback? onTap;
  final String? labelKey;
  _ActionItem({this.icon, this.onTap, this.labelKey});
}
