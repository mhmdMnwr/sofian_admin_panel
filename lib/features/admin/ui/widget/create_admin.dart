import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/core/widgets/alert_dialog.dart';
import 'package:sofian_admin_panel/core/widgets/app_form_filed.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class CreateAdmin extends StatefulWidget {
  const CreateAdmin({super.key});

  @override
  State<CreateAdmin> createState() => _CreateAdminState();
}

class _CreateAdminState extends State<CreateAdmin> {
  final Set<PermissionsTypes> _selectedPermissions = {};

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    return Dialog(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            AppAlertDialog.dialogHeader(
              context,
              title: localization.create_admin,
            ),
            verticalSpace(20),
            AppFormField(hintText: localization.name),
            verticalSpace(10),
            AppFormField(hintText: localization.phone_number),
            verticalSpace(10),
            AppFormField(hintText: localization.address),
            verticalSpace(10),
            AppFormField(hintText: localization.password),
            verticalSpace(10),
            _buildPermissionSection(context, localization),
          ],
        ),
      ),
    );
  }

  _buildPermissionSection(BuildContext context, localization) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.select_asigned_permissions,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        verticalSpace(15),
        _PermissionsRadioWidget(
          selectedPermissions: _selectedPermissions,
          onPermissionChanged: (permission, isSelected) {
            setState(() {
              if (isSelected) {
                _selectedPermissions.add(permission);
              } else {
                _selectedPermissions.remove(permission);
              }
            });
          },
        ),
      ],
    );
  }
}

class _PermissionsRadioWidget extends StatelessWidget {
  final Set<PermissionsTypes> selectedPermissions;
  final Function(PermissionsTypes permission, bool isSelected)
  onPermissionChanged;

  const _PermissionsRadioWidget({
    required this.selectedPermissions,
    required this.onPermissionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    // Get all available permissions except admins (usually restricted)
    final availablePermissions = PermissionsTypes.values
        .where((p) => p != PermissionsTypes.admins)
        .toList();

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.dividerColor),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        children: availablePermissions.map((permission) {
          final isSelected = selectedPermissions.contains(permission);
          return _buildPermissionRadioTile(
            context,
            permission,
            isSelected,
            localization,
            theme,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPermissionRadioTile(
    BuildContext context,
    PermissionsTypes permission,
    bool isSelected,
    AppLocalizations localization,
    ThemeData theme,
  ) {
    return InkWell(
      onTap: () => onPermissionChanged(permission, !isSelected),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.dividerColor.withOpacity(0.3),
              width: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _getPermissionIcon(permission),
              size: 24,
              color: isSelected
                  ? theme.primaryColor
                  : theme.iconTheme.color?.withOpacity(0.6),
            ),
            horizontalSpace(12),
            Expanded(
              child: Text(
                _getPermissionDisplayName(localization, permission),
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? theme.primaryColor
                      : theme.textTheme.bodyMedium?.color,
                ),
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: isSelected,
              onChanged: (value) {
                if (value != null) {
                  onPermissionChanged(permission, value);
                }
              },
              activeColor: theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  String _getPermissionDisplayName(
    AppLocalizations localization,
    PermissionsTypes permission,
  ) {
    switch (permission) {
      case PermissionsTypes.dashboard:
        return localization.dashboard;
      case PermissionsTypes.categories:
        return localization.categories;
      case PermissionsTypes.products:
        return localization.products;
      case PermissionsTypes.brands:
        return localization.brands;
      case PermissionsTypes.orders:
        return localization.orders;
      case PermissionsTypes.clients:
        return localization.clients;
      case PermissionsTypes.discounts:
        return localization.discounts;
      case PermissionsTypes.users:
        return localization.users;
      case PermissionsTypes.banners:
        return localization.banners;
      case PermissionsTypes.admins:
        return localization.admins;
    }
  }

  IconData _getPermissionIcon(PermissionsTypes permission) {
    switch (permission) {
      case PermissionsTypes.dashboard:
        return Icons.dashboard_outlined;
      case PermissionsTypes.categories:
        return Icons.category_outlined;
      case PermissionsTypes.products:
        return Icons.shopping_bag_outlined;
      case PermissionsTypes.brands:
        return Icons.branding_watermark_outlined;
      case PermissionsTypes.orders:
        return Icons.shopping_cart_outlined;
      case PermissionsTypes.clients:
        return Icons.people_outline;
      case PermissionsTypes.discounts:
        return Icons.discount_outlined;
      case PermissionsTypes.users:
        return Icons.person_outline;
      case PermissionsTypes.banners:
        return Icons.image_outlined;
      case PermissionsTypes.admins:
        return Icons.admin_panel_settings_outlined;
    }
  }
}
