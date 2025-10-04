import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

enum PermissionsTypes {
  dashboard,
  categories,
  products,
  brands,
  orders,
  clients,
  discounts,
  users,
  banners,
  admins,
}

class SideBarPages {
  SideBarPages({
    required this.title,
    required this.icon,
    required this.route,
    required this.permission,
  });

  final String title;
  final String icon;
  final String route;
  final PermissionsTypes permission;

  Widget getIconWidget(BuildContext context, bool isActive) {
    return Image.asset(
      icon,
      width: 26,
      height: 26,
      color: isActive
          ? ColorsManager.mainBlue
          : Theme.of(context).iconTheme.color,
    );
  }
}

List<SideBarPages> pages(BuildContext context) => [
  SideBarPages(
    title: AppLocalizations.of(context)!.dashboard,
    icon: IconsManager.dashboard,
    route: '/dashboard',
    permission: PermissionsTypes.dashboard,
  ),
  SideBarPages(
    title: AppLocalizations.of(context)!.categories,
    icon: IconsManager.categories,
    route: '/categories',
    permission: PermissionsTypes.categories,
  ),
  SideBarPages(
    title: AppLocalizations.of(context)!.products,
    icon: IconsManager.products,
    route: '/products',
    permission: PermissionsTypes.products,
  ),
  SideBarPages(
    title: AppLocalizations.of(context)!.brands,
    icon: IconsManager.brands,
    route: '/brands',
    permission: PermissionsTypes.brands,
  ),

  SideBarPages(
    title: AppLocalizations.of(context)!.orders,
    icon: IconsManager.orders,
    route: '/orders',
    permission: PermissionsTypes.orders,
  ),
  SideBarPages(
    title: AppLocalizations.of(context)!.clients,
    icon: IconsManager.clients,
    route: '/clients',
    permission: PermissionsTypes.clients,
  ),
  // SideBarPages(
  //   title: 'Users',
  //   icon: Icons.person,
  //   route: '/users',
  //   permission: PermissionsTypes.users,
  // ),
  SideBarPages(
    title: AppLocalizations.of(context)!.discounts,
    icon: IconsManager.discount,
    route: '/discounts',
    permission: PermissionsTypes.discounts,
  ),
  SideBarPages(
    title: AppLocalizations.of(context)!.banners,
    icon: IconsManager.banners,
    route: '/banners',
    permission: PermissionsTypes.banners,
  ),
  SideBarPages(
    title: AppLocalizations.of(context)!.admins,
    icon: IconsManager.banners,
    route: '/admins',
    permission: PermissionsTypes.admins,
  ),
];
