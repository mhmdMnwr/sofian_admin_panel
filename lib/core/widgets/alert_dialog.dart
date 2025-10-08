import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';

// Todo this is made by ai and i didnt test it yet

class AppAlertDialog extends StatelessWidget {
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

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        constraints: BoxConstraints(maxWidth: 400.w),
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title with close button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 18.sp,
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
            ),

            SizedBox(height: 16.h),

            // Content text
            Text(
              content,
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
            ),

            SizedBox(height: 24.h),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Primary button (e.g., Delete, Confirm)

                // Secondary button (e.g., Cancel)
                _buildButton(
                  context: context,
                  text: secondaryButtonText,
                  onTap: () {
                    Navigator.of(context).pop();
                    onSecondaryButtonTap();
                  },
                  backgroundColor:
                      secondaryButtonColor ?? const Color(0xFF5B9BD5),
                ),

                horizontalSpace(12),

                _buildButton(
                  context: context,
                  text: primaryButtonText,
                  onTap: () {
                    Navigator.of(context).pop();
                    onPrimaryButtonTap();
                  },
                  backgroundColor:
                      primaryButtonColor ?? const Color(0xFF5B9BD5),
                ),
              ],
            ),
          ],
        ),
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
        style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
      ),
    );
  }
}

/// Helper function to show the alert dialog
Future<void> showAppAlertDialog({
  required BuildContext context,
  required String title,
  required String content,
  required String primaryButtonText,
  required String secondaryButtonText,
  required VoidCallback onPrimaryButtonTap,
  required VoidCallback onSecondaryButtonTap,
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
      onPrimaryButtonTap: onPrimaryButtonTap,
      onSecondaryButtonTap: onSecondaryButtonTap,
      primaryButtonColor: primaryButtonColor,
      secondaryButtonColor: secondaryButtonColor,
    ),
  );
}
