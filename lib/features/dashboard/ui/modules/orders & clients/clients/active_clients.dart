import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/clients/clients_data_row.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/clients/clients_header_row.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/modules/orders%20&%20clients/clients/client_class.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class ActiveClients extends StatefulWidget {
  const ActiveClients({super.key});

  @override
  State<ActiveClients> createState() => _ActiveClientsState();
}

class _ActiveClientsState extends State<ActiveClients> {
  TimePeriod selectedPeriod = TimePeriod.lifetime;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 30.h, bottom: 30.h),
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
            _buildTitleWithDropdown(context),
            verticalSpace(24),
            Expanded(child: _buildClientsTable(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleWithDropdown(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            AppLocalizations.of(context)!.active_client,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: DropdownButton<TimePeriod>(
              value: selectedPeriod,
              underline: SizedBox.shrink(),
              items: TimePeriod.values.map((period) {
                return DropdownMenuItem(
                  value: period,
                  child: Text(
                    period.getDisplayText(context),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(fontSize: 11),
                  ),
                );
              }).toList(),
              onChanged: (TimePeriod? value) {
                if (value != null) {
                  setState(() {
                    selectedPeriod = value;
                  });
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClientsTable(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
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
        child: Column(
          children: [
            // Fixed Header Row
            const ClientsHeaderRow(),
            // Scrollable Data Rows
            Expanded(
              child: SingleChildScrollView(
                child: Column(children: _buildDataRows(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDataRows(BuildContext context) {
    return testClients
        .map((client) => ClientsDataRow.buildDataRow(context, client))
        .toList();
  }
}
