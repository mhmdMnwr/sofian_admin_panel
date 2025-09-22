import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/styles.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/features/login/ui/modules/PC/widget/logo.dart';

class SideBar extends StatefulWidget {
  final AdminModel admin;
  const SideBar({super.key, required this.admin});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    final List<SideBarPages> permittePages = permittedPages(
      widget.admin,
      pages(context),
    );
    setState(() {
      context.go(permittePages.first.route);
    });

    return Container(
      width: 250.w,
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Logo(horizontalPadding: 10),
          verticalSpace(30),
          Expanded(
            child: ListView.builder(
              itemCount: permittePages.length,
              itemBuilder: (context, index) {
                return _buildListTile(permittePages[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(SideBarPages page) {
    final currentRoute = GoRouterState.of(
      context,
    ).uri.toString(); // current URL
    final isActive = currentRoute == page.route;

    return Row(
      children: [
        if (isActive)
          Padding(
            padding: EdgeInsets.only(left: 0.w, right: 0),
            child: Container(
              width: 6.w,
              height: 60.h,
              decoration: BoxDecoration(
                color: ColorsManager.mainBlue,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
            ),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 0.w),
            child: ListTile(
              leading: page.getIconWidget(context, isActive),
              title: Text(
                page.title,
                style: isActive
                    ? TextStyles.font21mainBlueExtraBold
                    : Theme.of(context).textTheme.bodyMedium,
              ),
              onTap: () {
                context.go(page.route); // navigate to page route
              },
            ),
          ),
        ),
      ],
    );
  }
}

List<SideBarPages> permittedPages(
  AdminModel admin,
  List<SideBarPages> allPages,
) {
  if (admin.role == Role.superAdmin) {
    return allPages;
  } else if (admin.permissions != null) {
    return allPages
        .where((page) => admin.permissions!.contains(page.permission))
        .toList();
  } else {
    return [];
  }
}
