import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_model.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

String statusText(BuildContext context, Status status) {
  switch (status) {
    case Status.pending:
      return AppLocalizations.of(context)!.pending;
    case Status.delivered:
      return AppLocalizations.of(context)!.delivered;
    case Status.canceled:
      return AppLocalizations.of(context)!.canceled;
    case Status.processing:
      return AppLocalizations.of(context)!.processing;
    case Status.shipped:
      return AppLocalizations.of(context)!.shipped;
  }
}
