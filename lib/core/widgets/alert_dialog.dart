import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';

class AppAlertDialog extends StatefulWidget {
  final String title;
  final String content;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback onPrimaryButtonTap;
  final VoidCallback onSecondaryButtonTap;
  final Color? primaryButtonColor;
  final Color? secondaryButtonColor;

  const AppAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonText,
    required this.secondaryButtonText,
    required this.onPrimaryButtonTap,
    required this.onSecondaryButtonTap,
    this.primaryButtonColor,
    this.secondaryButtonColor,
  });

  static Widget dialogHeader(BuildContext context, {String title = ''}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.close),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  @override
  State<AppAlertDialog> createState() => _AppAlertDialogState();
}

class _AppAlertDialogState extends State<AppAlertDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Builder(
        builder: (dialogContext) {
          return Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with close button
                AppAlertDialog.dialogHeader(dialogContext, title: widget.title),

                verticalSpace(20),

                // Content text
                Text(
                  widget.content,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                ),

                verticalSpace(22),

                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Secondary button (e.g., Cancel)
                    _buildButton(
                      context: dialogContext,
                      text: widget.secondaryButtonText,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        widget.onSecondaryButtonTap();
                      },
                      backgroundColor:
                          widget.secondaryButtonColor ??
                          const Color(0xFF5B9BD5),
                    ),

                    horizontalSpace(12),

                    // Primary button (e.g., Delete, Confirm)
                    _buildButton(
                      context: dialogContext,
                      text: widget.primaryButtonText,
                      onTap: () {
                        Navigator.of(dialogContext).pop();
                        widget.onPrimaryButtonTap();
                      },
                      backgroundColor:
                          widget.primaryButtonColor ?? const Color(0xFF5B9BD5),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String text,
    required VoidCallback onTap,
    required Color backgroundColor,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 10.h),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.r)),
        elevation: 0,
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }
}

Future<void> showAppAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String primaryButtonText,
  required String secondaryButtonText,
  VoidCallback? onPrimaryButtonTap,
  VoidCallback? onSecondaryButtonTap,
  Color? primaryButtonColor,
  Color? secondaryButtonColor,
}) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) => AppAlertDialog(
      title: title,
      content: content,
      primaryButtonText: primaryButtonText,
      secondaryButtonText: secondaryButtonText,
      onPrimaryButtonTap: onPrimaryButtonTap ?? () {},
      onSecondaryButtonTap: onSecondaryButtonTap ?? () {},
      primaryButtonColor: primaryButtonColor,
      secondaryButtonColor: secondaryButtonColor,
    ),
  );
}
