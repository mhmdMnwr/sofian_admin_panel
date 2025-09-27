import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';

class ClientsDataRow extends StatelessWidget {
  const ClientsDataRow({super.key});

  static Widget buildDataRow(BuildContext context, client) {
    return Container(
      height: 70.h,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(bottom: BorderSide(color: Colors.grey, width: 0.8)),
      ),
      child: Row(
        children: [
          Container(
            width: 200.w,
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                Image.asset(IconsManager.profile, width: 60.w, height: 60.h),
                horizontalSpace(12),
                Expanded(
                  child: Text(
                    client.clientName,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  Text(
                    client.totalOrders.toString(),
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
                  ),
                  horizontalSpace(8.w),
                  Image.asset(IconsManager.cart, width: 30.w),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(); // Not used for DataTable
  }
}
