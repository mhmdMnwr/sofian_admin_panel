import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/widgets/generic_table.dart';
import 'package:sofian_admin_panel/core/widgets/search_bar.dart';
import 'package:sofian_admin_panel/features/clients/data/model/clinet_model.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class ClientsList extends StatefulWidget {
  const ClientsList({super.key});

  @override
  State<ClientsList> createState() => _ClientsListState();
}

class _ClientsListState extends State<ClientsList> {
  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return GenericTable(
      headers: [
        AppLocalizations.of(context)!.client_name,
        AppLocalizations.of(context)!.phone_number,
        AppLocalizations.of(context)!.join_date,
        AppLocalizations.of(context)!.total_spent,
        AppLocalizations.of(context)!.orders_count,
        AppLocalizations.of(context)!.last_order_date,
        AppLocalizations.of(context)!.email,
        AppLocalizations.of(context)!.address,
      ],
      data: getTestClinet(context),
      onDelete: (index) {},
      onEdit: (index) {},
      child: Padding(
        padding: EdgeInsets.only(top: 20.h, left: 20.w),
        child: Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: AppSearchBar(
            width: 400,
            hintText: AppLocalizations.of(context)!.search_for_clients,
          ),
        ),
      ),
    );
  }
}
