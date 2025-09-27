import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class HeaderRow extends StatelessWidget {
  const HeaderRow({super.key});

  static List<DataColumn> getColumns(BuildContext context) {
    return [
      DataColumn(
        label: Container(
          width: 200.w, // Fixed width matching data cells
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            AppLocalizations.of(context)!.userName,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
          ),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.order_id,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.total_price,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.status,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
        ),
      ),
      DataColumn(
        label: Text(
          AppLocalizations.of(context)!.action,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Not used for DataTable
  }
}
