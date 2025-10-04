import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/widgets/generic_table.dart';
import 'package:sofian_admin_panel/core/widgets/search_bar.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_model.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class OrdersList extends StatefulWidget {
  const OrdersList({super.key});

  @override
  State<OrdersList> createState() => _OrdersListState();
}

class _OrdersListState extends State<OrdersList> {
  // late final List<List<dynamic>> orders;

  // @override
  // void initState() {
  //   super.initState();
  //   orders = getFullOrdersList(context);
  // }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return GenericTable(
      headers: [
        AppLocalizations.of(context)!.userName,
        AppLocalizations.of(context)!.order_id,
        AppLocalizations.of(context)!.time,
        AppLocalizations.of(context)!.date,
        AppLocalizations.of(context)!.total_price,
        AppLocalizations.of(context)!.status,
      ],

      data: getFullOrdersList(context),
      onDelete: (index) {},
      onEdit: (index) {},
      child: Padding(
        padding: EdgeInsets.only(top: 20.h, left: 20.w),
        child: Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: AppSearchBar(
            width: 400,
            hintText: AppLocalizations.of(context)!.search_for_orders,
          ),
        ),
      ),
    );
  }
}
