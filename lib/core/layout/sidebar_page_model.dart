import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';

enum Permissions {
  dashboard,
  categories,
  products,
  marks,
  reduction,
  orders,
  clients,
  users,
  banners,
}

class SideBarPages {
  SideBarPages({
    required this.title,
    required this.icon,
    required this.route,
    required this.permission,
    this.isActive = false,
  });

  final String title;
  final String icon;
  final String route;
  final Permissions permission;
  bool isActive;

  Widget getIconWidget(BuildContext context) {
    return Image.asset(
      icon,
      width: 28.sp,
      height: 28.sp,
      color: isActive
          ? ColorsManager.mainBlue
          : Theme.of(context).iconTheme.color,
    );
  }
}
