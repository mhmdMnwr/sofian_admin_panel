import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TableStyles {
  // Colors
  static Color getBorderColor() => Colors.grey;
  static Color getShadowColor() => Colors.black.withValues(alpha: 0.1);

  // Dimensions
  static double get borderRadius => 8.r;
  static double get clipRadius => 12.r;
  static double get borderWidth => 0.8;
  static double get shadowBlurRadius => 4.0;
  static Offset get shadowOffset => const Offset(0, 2);

  // Heights
  static double get headerHeight => 56.0;
  static double get rowHeight => 60.0;

  // Padding and margins
  static EdgeInsets get containerPadding =>
      EdgeInsets.only(top: 30.h, bottom: 10.h);
  static EdgeInsets get headerPadding => EdgeInsets.symmetric(horizontal: 20.w);
  static EdgeInsets get cellPadding => EdgeInsets.only(left: 20.w, right: 5.w);

  // Responsive padding for fixed columns
  static EdgeInsets getFixedCellPadding(double screenWidth) {
    return EdgeInsets.symmetric(
      horizontal: 12.w,
      vertical: screenWidth > 768 ? 12 : 8,
    );
  }

  // Font sizes
  static double getHeaderFontSize(double screenWidth) {
    return screenWidth > 768 ? 16 : 14;
  }

  static double getFixedHeaderFontSize(double screenWidth) {
    return screenWidth > 768 ? 14 : 12;
  }

  static double getCellFontSize(double screenWidth) {
    return screenWidth > 768 ? 15 : 13;
  }

  static double getFixedCellFontSize(double screenWidth) {
    return screenWidth > 768 ? 13 : 11;
  }

  // Column width calculations
  static double getMinColumnWidth(double screenWidth) {
    return screenWidth > 768 ? 150 : 120;
  }

  static double getMaxColumnWidth(double screenWidth) {
    return screenWidth > 1200 ? 250 : 200;
  }

  // Layout calculations
  static double getAvailableWidth(double screenWidth) {
    return screenWidth - 60; // Account for padding
  }

  static double getMaxAvailableHeight(double screenHeight) {
    return screenHeight - (screenHeight * 0.25); // 25% for other elements
  }

  static double getTableHeight(double maxAvailableHeight) {
    return maxAvailableHeight * 0.85;
  }

  // Decorations
  static BoxDecoration getContainerDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: [
        BoxShadow(
          color: getShadowColor(),
          blurRadius: shadowBlurRadius,
          offset: shadowOffset,
        ),
      ],
    );
  }

  static BoxDecoration getHeaderDecoration(BuildContext context) {
    return BoxDecoration(
      color: Theme.of(context).primaryColor,
      border: Border(
        bottom: BorderSide(color: getBorderColor(), width: borderWidth),
      ),
    );
  }

  static BoxDecoration getRowDecoration(BuildContext context, int index) {
    return BoxDecoration(
      color: index.isEven
          ? Theme.of(context).scaffoldBackgroundColor
          : Theme.of(context).primaryColor,
      border: Border(
        bottom: BorderSide(color: getBorderColor(), width: borderWidth),
      ),
    );
  }

  // Text styles
  static TextStyle getHeaderTextStyle(
    BuildContext context,
    double screenWidth,
  ) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: getHeaderFontSize(screenWidth),
        ) ??
        const TextStyle();
  }

  static TextStyle getFixedHeaderTextStyle(
    BuildContext context,
    double screenWidth,
  ) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: getFixedHeaderFontSize(screenWidth),
        ) ??
        const TextStyle();
  }

  static TextStyle getCellTextStyle(BuildContext context, double screenWidth) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: getCellFontSize(screenWidth),
        ) ??
        const TextStyle();
  }

  static TextStyle getFixedCellTextStyle(
    BuildContext context,
    double screenWidth,
  ) {
    return Theme.of(context).textTheme.bodyMedium?.copyWith(
          fontSize: getFixedCellFontSize(screenWidth),
        ) ??
        const TextStyle();
  }
}
