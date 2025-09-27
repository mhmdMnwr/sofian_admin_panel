import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class ClientItem {
  final String clientName;
  final int totalOrders;

  const ClientItem({required this.clientName, required this.totalOrders});
}

enum TimePeriod { lastWeek, lastMonth, lifetime }

extension TimePeriodExtension on TimePeriod {
  String getDisplayText(BuildContext context) {
    switch (this) {
      case TimePeriod.lastWeek:
        return AppLocalizations.of(context)!.last_7_days;
      case TimePeriod.lastMonth:
        return AppLocalizations.of(context)!.last_month;
      case TimePeriod.lifetime:
        return AppLocalizations.of(context)!.life_time;
    }
  }
}
//TODO this is a fake data base so change it to a real data source

final List<ClientItem> testClients = [
  ClientItem(clientName: 'أحمد محمد علي', totalOrders: 45),
  ClientItem(clientName: 'فاطمة سعد الدين', totalOrders: 32),
  ClientItem(clientName: 'محمد عبد الرحمن', totalOrders: 28),
  ClientItem(clientName: 'نور الهدى حسن', totalOrders: 21),
  ClientItem(clientName: 'عمر خالد السيد', totalOrders: 18),
  ClientItem(clientName: 'سارة أحمد محمود', totalOrders: 15),
  ClientItem(clientName: 'يوسف عبد الله', totalOrders: 12),
  ClientItem(clientName: 'مريم حسام الدين', totalOrders: 8),
  ClientItem(clientName: 'علي محمد صالح', totalOrders: 25),
  ClientItem(clientName: 'هدى عبد الكريم', totalOrders: 6),
  ClientItem(clientName: 'حسام الدين أحمد', totalOrders: 38),
  ClientItem(clientName: 'رانيا محمد علي', totalOrders: 19),
  ClientItem(clientName: 'كريم عبد الرحيم', totalOrders: 29),
  ClientItem(clientName: 'ليلى سعد محمد', totalOrders: 4),
  ClientItem(clientName: 'طارق عبد العزيز', totalOrders: 41),
];
