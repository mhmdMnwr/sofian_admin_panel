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
    return Container(
      height: 60.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.userName,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.order_id,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.total_price,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.status,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Text(
                AppLocalizations.of(context)!.action,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
