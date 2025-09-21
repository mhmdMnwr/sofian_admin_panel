import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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

  late final String title;
  late final IconData icon;
  late final String route;
  late final Permissions permission;
  final bool isActive;

  set isActive() => isActive = !this.isActive;
}

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final List<SideBarPages> pages = [
    SideBarPages(
      title: 'Dashboard',
      icon: Icons.dashboard,
      route: '/dashboard',
      permission: Permissions.dashboard,
    ),
    SideBarPages(
      title: 'Categories',
      icon: Icons.category,
      route: '/categories',
      permission: Permissions.categories,
    ),
    SideBarPages(
      title: 'Products',
      icon: Icons.shopping_bag,
      route: '/products',
      permission: Permissions.products,
    ),
    SideBarPages(
      title: 'Marks',
      icon: Icons.branding_watermark,
      route: '/marks',
      permission: Permissions.marks,
    ),
    SideBarPages(
      title: 'Reduction',
      icon: Icons.discount,
      route: '/reduction',
      permission: Permissions.reduction,
    ),
    SideBarPages(
      title: 'Orders',
      icon: Icons.receipt_long,
      route: '/orders',
      permission: Permissions.orders,
      isActive: true,
    ),
    SideBarPages(
      title: 'Clients',
      icon: Icons.people,
      route: '/clients',
      permission: Permissions.clients,
    ),
    // SideBarPages(
    //   title: 'Users',
    //   icon: Icons.person,
    //   route: '/users',
    //   permission: Permissions.users,
    // ),
    SideBarPages(
      title: 'Banners',
      icon: Icons.image,
      route: '/banners',
      permission: Permissions.banners,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260.w,
      color: Theme.of(context).primaryColor,
      child: ListView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) {
          final page = pages[index];
          return ListTile(
            leading: Icon(page.icon, size: 24.sp , color: page.isActive ? ColorsManager.mainBlue : Theme.of(context).textTheme.labelLarge?.color),
            title: Text(page.title , style: Theme.of(context).textTheme.labelLarge,),
            onTap: () {
              Navigator.pushNamed(context, page.route);
            },
          );
        },
      ),
    );
  }
}
