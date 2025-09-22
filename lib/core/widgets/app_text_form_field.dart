import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final bool digitOnly;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final TextEditingController? controller;
  final Function(String?) validator;
  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.digitOnly = false,
    this.prefixIcon,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: digitOnly ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.mainBlue, width: 5.sp),
          // borderRadius: BorderRadius.circular(16.0),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: ColorsManager.mainBlue, width: 5.sp),
          // borderRadius: BorderRadius.circular(16.0),
        ),
        errorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          // borderRadius: BorderRadius.circular(16.0),
        ),
        focusedErrorBorder: UnderlineInputBorder(
          borderSide: const BorderSide(color: Colors.red, width: 1.3),
          // borderRadius: BorderRadius.circular(16.0),
        ),
        hintText: hintText,
        hintStyle: hintStyle ?? TextStyles.hint,

        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,

        fillColor: backgroundColor ?? Colors.white,
        // filled: true,
      ),
      obscureText: isObscureText ?? false,
      style: TextStyles.font20fromblackMedium,
      validator: (value) {
        return validator(value);
      },
    );
  }
}
