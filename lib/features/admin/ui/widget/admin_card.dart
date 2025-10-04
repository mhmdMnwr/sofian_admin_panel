import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/font_weight.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class AdminCard extends StatelessWidget {
  final AdminModel admin;

  const AdminCard({super.key, required this.admin});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: ColorsManager.mainBlue.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with User ID and Delete button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: ColorsManager.mainBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    'User ${admin.id.padLeft(2, '0')}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: ColorsManager.mainBlue,
                      fontWeight: FontWeightHelper.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    // TODO: Implement delete functionality
                  },
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            verticalSpace(16),

            // Name
            _buildInfoRow(
              context,
              icon: Icons.person_outline,
              label: localizations.name,
              value: admin.name ?? 'N/A',
            ),
            verticalSpace(12),

            // Phone Number
            _buildInfoRow(
              context,
              icon: Icons.phone_outlined,
              label: localizations.phone_number,
              value: admin.phoneNumber ?? 'N/A',
            ),
            verticalSpace(12),

            // Address
            _buildInfoRow(
              context,
              icon: Icons.location_on_outlined,
              label: localizations.address,
              value: admin.address ?? 'N/A',
            ),
            verticalSpace(12),

            // Join Date
            _buildInfoRow(
              context,
              icon: Icons.calendar_today_outlined,
              label: localizations.join_date,
              value: admin.joinDate ?? 'N/A',
            ),
            verticalSpace(16),

            // Assigned Sections
            Text(
              'Assigned sections :',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeightHelper.semiBold,
                fontSize: 15,
              ),
            ),
            verticalSpace(8),

            // Permissions List
            Expanded(
              child: SingleChildScrollView(
                child: _buildPermissionsList(context),
              ),
            ),

            verticalSpace(16),

            // Edit Button (Fixed at bottom)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // TODO: Implement edit functionality
                },
                icon: const Icon(Icons.edit),
                label: Text(
                  localizations.edit,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorsManager.mainBlue,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: theme.iconTheme.color?.withOpacity(0.7)),
        horizontalSpace(8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$label :',
                style: theme.textTheme.bodySmall?.copyWith(
                  fontSize: 13,
                  color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                ),
              ),
              verticalSpace(2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeightHelper.medium,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionsList(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    if (admin.role == Role.superAdmin) {
      return _buildPermissionChip(
        context,
        localizations.permissions,
        Icons.verified,
      );
    }

    if (admin.permissions == null || admin.permissions!.isEmpty) {
      return Text(
        'No permissions assigned',
        style: theme.textTheme.bodySmall?.copyWith(
          fontSize: 14,
          fontStyle: FontStyle.italic,
        ),
      );
    }

    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: admin.permissions!.map((permission) {
        return _buildPermissionChip(
          context,
          _getPermissionDisplayName(context, permission),
          _getPermissionIcon(permission),
        );
      }).toList(),
    );
  }

  Widget _buildPermissionChip(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: theme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6.r),
        border: Border.all(
          color: theme.primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.iconTheme.color),
          horizontalSpace(6),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 14,
              fontWeight: FontWeightHelper.medium,
            ),
          ),
        ],
      ),
    );
  }

  String _getPermissionDisplayName(
    BuildContext context,
    PermissionsTypes permission,
  ) {
    final localizations = AppLocalizations.of(context)!;

    switch (permission) {
      case PermissionsTypes.dashboard:
        return localizations.dashboard;
      case PermissionsTypes.categories:
        return localizations.categories;
      case PermissionsTypes.products:
        return localizations.products;
      case PermissionsTypes.brands:
        return localizations.brands;
      case PermissionsTypes.orders:
        return localizations.orders;
      case PermissionsTypes.clients:
        return localizations.clients;
      case PermissionsTypes.discounts:
        return localizations.discounts;
      case PermissionsTypes.users:
        return localizations.users;
      case PermissionsTypes.banners:
        return localizations.banners;
      case PermissionsTypes.admins:
        return localizations.admins;
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
        return Icons.image_outlined;
    }
  }
}
