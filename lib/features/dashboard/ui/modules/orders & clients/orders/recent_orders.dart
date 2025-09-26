import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/data_row.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/orders/header_row.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class RecentOrders extends StatelessWidget {
  const RecentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h),
      child: Container(
        constraints: BoxConstraints(maxHeight: 800.h, minHeight: 300.h),

        padding: EdgeInsets.only(top: 26.h),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            verticalSpace(24),
            Expanded(child: _buildOrdersTable(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 20.w),
      child: Text(
        AppLocalizations.of(context)!.recent_orders,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
      ),
    );
  }

  Widget _buildOrdersTable(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 0,
            horizontalMargin: 0,
            headingRowHeight: 60.h,
            dataRowHeight: 70.h,
            headingRowColor: MaterialStateProperty.all(
              Theme.of(context).primaryColor,
            ),
            dividerThickness: 1,
            border: TableBorder(
              horizontalInside: BorderSide(
                color: Theme.of(context).iconTheme.color!,
                width: 0.8,
              ),
            ),
            headingTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15.sp,
            ),
            dataTextStyle: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
            columns: HeaderRow.getColumns(context),
            rows: OrdersDataRow.getRows(context),
          ),
        ),
      ),
    );
  }
}
