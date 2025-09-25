import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/layout/side_bar.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/core/layout/settings_row.dart';
import 'package:sofian_admin_panel/l10n/cubit/locale_cubit.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, state) {
          final isRTL = context.read<LocaleCubit>().isRTL;

          return Row(
            textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
            children: [
              SideBar(admin: superAdmin),
              Expanded(
                child: Column(
                  children: [
                    SettingsRow(),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: child,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

final AdminModel superAdmin = AdminModel(
  id: 'super_admin_001',
  userName: 'superadmin',

  role: Role.superAdmin,
  permissions: sommePermissions, // All permissions
);

List<PermissionsTypes> sommePermissions = [
  PermissionsTypes.orders,
  PermissionsTypes.clients,
  PermissionsTypes.discounts,
  PermissionsTypes.products,
];
