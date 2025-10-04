import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/styles.dart';

class AppDropDownMenu<T> extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?)? onChanged;
  final String? Function(T?)? validator;
  final bool enabled;
  final double? dropdownMaxHeight;
  final Widget? underline;
  final bool isDense;
  final FocusNode? focusNode;

  const AppDropDownMenu({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.value,
    required this.items,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.dropdownMaxHeight,
    this.underline,
    this.isDense = true,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      focusNode: focusNode,
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      validator: validator,
      isExpanded: true,
      isDense: isDense,
      menuMaxHeight: dropdownMaxHeight ?? 500.h,
      decoration: InputDecoration(
        isDense: isDense,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder:
            focusedBorder ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorsManager.mainBlue,
                width: 5.sp,
              ),
            ),
        enabledBorder:
            enabledBorder ??
            UnderlineInputBorder(
              borderSide: BorderSide(
                color: ColorsManager.mainBlue,
                width: 5.sp,
              ),
            ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
        ),
        disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.pending, width: 5.sp),
        ),
        hintText: hintText,
        hintStyle: TextStyles.hint,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: backgroundColor ?? Colors.white,
        filled: backgroundColor != null,
      ),
      style: inputTextStyle ?? TextStyles.font20fromblackMedium,
      icon: const Icon(
        Icons.keyboard_arrow_down,
        color: ColorsManager.mainBlue,
      ),
      dropdownColor: Colors.white,
      borderRadius: BorderRadius.circular(8.r),
    );
  }
}

// Extension to make it easier to create dropdown items
extension DropdownItemHelper on AppDropDownMenu {
  static List<DropdownMenuItem<String>> createStringItems(
    List<String> items, {
    TextStyle? itemStyle,
  }) {
    return items
        .map(
          (item) => DropdownMenuItem<String>(
            value: item,
            // Use Align + single-line ellipsis to avoid layout overflow
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: itemStyle ?? TextStyles.font20fromblackMedium,
              ),
            ),
          ),
        )
        .toList();
  }

  static List<DropdownMenuItem<T>> createCustomItems<T>(
    List<T> items, {
    required String Function(T) getDisplayText,
    TextStyle? itemStyle,
  }) {
    return items
        .map(
          (item) => DropdownMenuItem<T>(
            value: item,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                getDisplayText(item),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                softWrap: false,
                style: itemStyle ?? TextStyles.font20fromblackMedium,
              ),
            ),
          ),
        )
        .toList();
  }
}

// Predefined dropdown items for common use cases
class CommonDropdownItems {
  static List<DropdownMenuItem<String>> get yesNo => [
    const DropdownMenuItem<String>(value: 'yes', child: Text('Yes')),
    const DropdownMenuItem<String>(value: 'no', child: Text('No')),
  ];

  static List<DropdownMenuItem<String>> get status => [
    const DropdownMenuItem<String>(value: 'active', child: Text('Active')),
    const DropdownMenuItem<String>(value: 'inactive', child: Text('Inactive')),
    const DropdownMenuItem<String>(value: 'pending', child: Text('Pending')),
  ];

  static List<DropdownMenuItem<String>> get priority => [
    const DropdownMenuItem<String>(value: 'high', child: Text('High')),
    const DropdownMenuItem<String>(value: 'medium', child: Text('Medium')),
    const DropdownMenuItem<String>(value: 'low', child: Text('Low')),
  ];
}
