import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

/// Helper class to handle RTL/LTR specific styling and layout
class RTLHelper {
  /// Get appropriate EdgeInsets for RTL/LTR
  static EdgeInsets getDirectionalEdgeInsets({
    required BuildContext context,
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) {
    final isRTL = context.read<LocaleCubit>().isRTL;
    if (isRTL) {
      return EdgeInsets.fromLTRB(right, top, left, bottom);
    }
    return EdgeInsets.fromLTRB(left, top, right, bottom);
  }

  /// Get appropriate Alignment for RTL/LTR
  static Alignment getDirectionalAlignment({
    required BuildContext context,
    required Alignment ltrAlignment,
  }) {
    final isRTL = context.read<LocaleCubit>().isRTL;
    if (!isRTL) return ltrAlignment;

    // Flip horizontal alignments for RTL
    if (ltrAlignment == Alignment.centerLeft) {
      return Alignment.centerRight;
    } else if (ltrAlignment == Alignment.centerRight) {
      return Alignment.centerLeft;
    } else if (ltrAlignment == Alignment.topLeft) {
      return Alignment.topRight;
    } else if (ltrAlignment == Alignment.topRight) {
      return Alignment.topLeft;
    } else if (ltrAlignment == Alignment.bottomLeft) {
      return Alignment.bottomRight;
    } else if (ltrAlignment == Alignment.bottomRight) {
      return Alignment.bottomLeft;
    }

    return ltrAlignment;
  }

  /// Get appropriate TextAlign for RTL/LTR
  static TextAlign getDirectionalTextAlign({
    required BuildContext context,
    TextAlign defaultAlign = TextAlign.start,
  }) {
    final isRTL = context.read<LocaleCubit>().isRTL;

    if (defaultAlign == TextAlign.start) {
      return isRTL ? TextAlign.right : TextAlign.left;
    } else if (defaultAlign == TextAlign.end) {
      return isRTL ? TextAlign.left : TextAlign.right;
    }

    return defaultAlign;
  }

  /// Get appropriate MainAxisAlignment for Row widgets in RTL/LTR
  static MainAxisAlignment getDirectionalMainAxisAlignment({
    required BuildContext context,
    required MainAxisAlignment ltrAlignment,
  }) {
    final isRTL = context.read<LocaleCubit>().isRTL;
    if (!isRTL) return ltrAlignment;

    // Flip alignments for RTL
    if (ltrAlignment == MainAxisAlignment.start) {
      return MainAxisAlignment.end;
    } else if (ltrAlignment == MainAxisAlignment.end) {
      return MainAxisAlignment.start;
    }

    return ltrAlignment;
  }

  /// Create a directionally-aware Positioned widget
  static Positioned getDirectionalPositioned({
    required BuildContext context,
    required Widget child,
    double? left,
    double? top,
    double? right,
    double? bottom,
    double? width,
    double? height,
  }) {
    final isRTL = context.read<LocaleCubit>().isRTL;

    if (isRTL) {
      return Positioned(
        left: right,
        top: top,
        right: left,
        bottom: bottom,
        width: width,
        height: height,
        child: child,
      );
    }

    return Positioned(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}

/// Extension to easily access RTL helper methods
extension RTLContextExtension on BuildContext {
  bool get isRTL => read<LocaleCubit>().isRTL;
  TextDirection get textDirection => read<LocaleCubit>().textDirection;

  EdgeInsets directionalEdgeInsets({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => RTLHelper.getDirectionalEdgeInsets(
    context: this,
    left: left,
    top: top,
    right: right,
    bottom: bottom,
  );

  Alignment directionalAlignment(Alignment ltrAlignment) =>
      RTLHelper.getDirectionalAlignment(
        context: this,
        ltrAlignment: ltrAlignment,
      );

  TextAlign directionalTextAlign([TextAlign defaultAlign = TextAlign.start]) =>
      RTLHelper.getDirectionalTextAlign(
        context: this,
        defaultAlign: defaultAlign,
      );
}
