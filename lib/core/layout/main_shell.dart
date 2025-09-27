import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/layout/drawer.dart';
import 'package:sofian_admin_panel/core/layout/side_bar.dart';
import 'package:sofian_admin_panel/core/layout/settings_row.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  final AdminModel? admin;

  const MainShell({super.key, required this.child, this.admin});

  @override
  Widget build(BuildContext context) {
    final currentAdmin = admin ?? superAdmin;

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, localeState) {
        final isRTL = context.read<LocaleCubit>().isRTL;

        return LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final isTablet = width < AppConstants.tabletBreakPoint;

            return Directionality(
              textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
              child: Scaffold(
                drawer: isTablet
                    ? Drawer(child: AppDrawer(admin: currentAdmin))
                    : null,
                body: SafeArea(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!isTablet)
                        SizedBox(
                          width: 260.w,
                          child: SideBar(admin: currentAdmin),
                        ),
                      Expanded(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                if (isTablet) _buildDrawerIcon(),
                                const Spacer(),
                                const SettingsRow(),
                              ],
                            ),
                            Expanded(child: child),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildDrawerIcon() {
    return Builder(
      builder: (ctx) {
        return IconButton(
          onPressed: () => Scaffold.of(ctx).openDrawer(),
          icon: const Icon(Icons.menu, size: 30),
        );
      },
    );
  }
}

final List<PermissionsTypes> sommePermissions = [
  PermissionsTypes.orders,
  PermissionsTypes.clients,
  PermissionsTypes.discounts,
  PermissionsTypes.products,
];

final AdminModel superAdmin = AdminModel(
  id: 'super_admin_001',
  userName: 'superadmin',
  role: Role.superAdmin,
  permissions: sommePermissions,
);
