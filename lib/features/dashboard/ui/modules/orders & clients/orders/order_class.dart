import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class OrderItem {
  final String clientName;
  final String orderId;
  final double totalPrice;
  final Status status;
  const OrderItem({
    required this.totalPrice,
    required this.clientName,
    required this.orderId,
    required this.status,
  });

  String statusText(BuildContext context) {
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

  get statusColor {
    switch (status) {
      case Status.pending:
        return ColorsManager.pending;
      case Status.delivered:
        return ColorsManager.delivered;
      case Status.canceled:
        return ColorsManager.lossRed;
      case Status.processing:
        return ColorsManager.processing;
      case Status.shipped:
        return Colors.white;
    }
  }

  Widget buildStatusBadge(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 26.w, vertical: 16.h),

      child: Container(
        decoration: BoxDecoration(
          color: statusColor,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Center(
          child: Text(
            statusText(context),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
        ),
      ),
    );
  }
}

enum Status { pending, delivered, canceled, processing, shipped }

final List<OrderItem> testOrders = [
  OrderItem(
    clientName: 'John Doe',
    orderId: 'ORD001',
    totalPrice: 250.00,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'Sarah Smith',
    orderId: 'ORD002',
    totalPrice: 125.50,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Mike Johnson',
    orderId: 'ORD003',
    totalPrice: 89.99,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Emily Davis',
    orderId: 'ORD004',
    totalPrice: 340.75,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'David Wilson',
    orderId: 'ORD005',
    totalPrice: 78.25,
    status: Status.canceled,
  ),
  OrderItem(
    clientName: 'Lisa Brown',
    orderId: 'ORD006',
    totalPrice: 195.30,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'James Miller',
    orderId: 'ORD007',
    totalPrice: 412.80,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Anna Garcia',
    orderId: 'ORD008',
    totalPrice: 67.45,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Tom Anderson',
    orderId: 'ORD009',
    totalPrice: 299.99,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'Maria Rodriguez',
    orderId: 'ORD010',
    totalPrice: 156.20,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'Chris Taylor',
    orderId: 'ORD011',
    totalPrice: 88.60,
    status: Status.canceled,
  ),
  OrderItem(
    clientName: 'Jessica White',
    orderId: 'ORD012',
    totalPrice: 234.75,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Robert Lee',
    orderId: 'ORD013',
    totalPrice: 145.90,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Amanda Clark',
    orderId: 'ORD014',
    totalPrice: 378.50,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'Kevin Martinez',
    orderId: 'ORD015',
    totalPrice: 92.35,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'Nicole Thomas',
    orderId: 'ORD016',
    totalPrice: 267.80,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Ryan Jackson',
    orderId: 'ORD017',
    totalPrice: 189.45,
    status: Status.canceled,
  ),
  OrderItem(
    clientName: 'Stephanie Harris',
    orderId: 'ORD018',
    totalPrice: 324.15,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Brandon Moore',
    orderId: 'ORD019',
    totalPrice: 75.90,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'Rachel Thompson',
    orderId: 'ORD020',
    totalPrice: 201.65,
    status: Status.pending,
  ),
];
