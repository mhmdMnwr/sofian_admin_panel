import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

/// A widget that automatically wraps its child with Directionality
/// based on the current locale (RTL for Arabic, LTR for others)
class DirectionalWrapper extends StatelessWidget {
  final Widget child;

  const DirectionalWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final textDirection = context.read<LocaleCubit>().textDirection;

        return Directionality(textDirection: textDirection, child: child);
      },
    );
  }
}

/// A custom scaffold that automatically handles RTL/LTR direction
class DirectionalScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? endDrawer;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;

  const DirectionalScaffold({
    super.key,
    this.appBar,
    this.body,
    this.floatingActionButton,
    this.drawer,
    this.endDrawer,
    this.backgroundColor,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return DirectionalWrapper(
      child: Scaffold(
        appBar: appBar,
        body: body,
        floatingActionButton: floatingActionButton,
        drawer: drawer,
        endDrawer: endDrawer,
        backgroundColor: backgroundColor,
        bottomNavigationBar: bottomNavigationBar,
      ),
    );
  }
}

/// A custom container that automatically applies proper alignment for RTL/LTR
class DirectionalContainer extends StatelessWidget {
  final Widget? child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;

  const DirectionalContainer({
    super.key,
    this.child,
    this.padding,
    this.margin,
    this.color,
    this.decoration,
    this.width,
    this.height,
    this.alignment,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final isRTL = context.read<LocaleCubit>().isRTL;

        // Adjust alignment for RTL
        AlignmentGeometry? adjustedAlignment = alignment;
        if (alignment != null && isRTL) {
          if (alignment == Alignment.centerLeft) {
            adjustedAlignment = Alignment.centerRight;
          } else if (alignment == Alignment.centerRight) {
            adjustedAlignment = Alignment.centerLeft;
          }
        }

        return Container(
          width: width,
          height: height,
          padding: padding,
          margin: margin,
          color: color,
          decoration: decoration,
          alignment: adjustedAlignment,
          child: child,
        );
      },
    );
  }
}

/// A row that automatically reverses its children order for RTL languages
class DirectionalRow extends StatelessWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisSize mainAxisSize;

  const DirectionalRow({
    super.key,
    required this.children,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisSize = MainAxisSize.max,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        final isRTL = context.read<LocaleCubit>().isRTL;

        // Reverse children order for RTL
        final adjustedChildren = isRTL ? children.reversed.toList() : children;

        // Adjust main axis alignment for RTL
        MainAxisAlignment adjustedMainAxisAlignment = mainAxisAlignment;
        if (isRTL) {
          switch (mainAxisAlignment) {
            case MainAxisAlignment.start:
              adjustedMainAxisAlignment = MainAxisAlignment.end;
              break;
            case MainAxisAlignment.end:
              adjustedMainAxisAlignment = MainAxisAlignment.start;
              break;
            default:
              adjustedMainAxisAlignment = mainAxisAlignment;
          }
        }

        return Row(
          mainAxisAlignment: adjustedMainAxisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          mainAxisSize: mainAxisSize,
          children: adjustedChildren,
        );
      },
    );
  }
}
