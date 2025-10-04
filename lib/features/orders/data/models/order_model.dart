import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class OrderItem {
  final String clientName;
  final String orderId;
  final String time;
  final String date;
  final double totalPrice;
  final Status status;
  const OrderItem({
    required this.totalPrice,
    required this.clientName,
    required this.date,
    required this.time,
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
      padding: EdgeInsets.symmetric(vertical: 14.h),

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
              fontSize: 14,
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
    time: '10:30 AM',
    date: '2024-10-04',
    totalPrice: 250.00,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'Sarah Smith',
    orderId: 'ORD002',
    time: '02:15 PM',
    date: '2024-10-04',
    totalPrice: 125.50,
    status: Status.delivered,
  ),
  OrderItem(
    clientName:
        'ameur mohammed menouer is trying to type a long text here to se how flutter behave in that case , thanks',
    orderId: 'ORD003',
    time: '09:45 AM',
    date: '2024-10-03',
    totalPrice: 89.99,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Emily Davis',
    orderId: 'ORD004',
    time: '04:20 PM',
    date: '2024-10-03',
    totalPrice: 340.75,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'David Wilson',
    orderId: 'ORD005',
    time: '11:00 AM',
    date: '2024-10-02',
    totalPrice: 78.25,
    status: Status.canceled,
  ),
  OrderItem(
    clientName: 'Lisa Brown',
    orderId: 'ORD006',
    time: '01:30 PM',
    date: '2024-10-02',
    totalPrice: 195.30,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'James Miller',
    orderId: 'ORD007',
    time: '03:45 PM',
    date: '2024-10-01',
    totalPrice: 412.80,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Anna Garcia',
    orderId: 'ORD008',
    time: '08:15 AM',
    date: '2024-10-01',
    totalPrice: 67.45,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Tom Anderson',
    orderId: 'ORD009',
    time: '05:30 PM',
    date: '2024-09-30',
    totalPrice: 299.99,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'Maria Rodriguez',
    orderId: 'ORD010',
    time: '12:00 PM',
    date: '2024-09-30',
    totalPrice: 156.20,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'Chris Taylor',
    orderId: 'ORD011',
    time: '07:20 AM',
    date: '2024-09-29',
    totalPrice: 88.60,
    status: Status.canceled,
  ),
  OrderItem(
    clientName: 'Jessica White',
    orderId: 'ORD012',
    time: '02:50 PM',
    date: '2024-09-29',
    totalPrice: 234.75,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Robert Lee',
    orderId: 'ORD013',
    time: '10:15 AM',
    date: '2024-09-28',
    totalPrice: 145.90,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Amanda Clark',
    orderId: 'ORD014',
    time: '04:45 PM',
    date: '2024-09-28',
    totalPrice: 378.50,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'Kevin Martinez',
    orderId: 'ORD015',
    time: '11:30 AM',
    date: '2024-09-27',
    totalPrice: 92.35,
    status: Status.pending,
  ),
  OrderItem(
    clientName: 'Nicole Thomas',
    orderId: 'ORD016',
    time: '01:15 PM',
    date: '2024-09-27',
    totalPrice: 267.80,
    status: Status.delivered,
  ),
  OrderItem(
    clientName: 'Ryan Jackson',
    orderId: 'ORD017',
    time: '09:00 AM',
    date: '2024-09-26',
    totalPrice: 189.45,
    status: Status.canceled,
  ),
  OrderItem(
    clientName: 'Stephanie Harris',
    orderId: 'ORD018',
    time: '03:25 PM',
    date: '2024-09-26',
    totalPrice: 324.15,
    status: Status.processing,
  ),
  OrderItem(
    clientName: 'Brandon Moore',
    orderId: 'ORD019',
    time: '06:10 PM',
    date: '2024-09-25',
    totalPrice: 75.90,
    status: Status.shipped,
  ),
  OrderItem(
    clientName: 'Rachel Thompson',
    orderId: 'ORD020',
    time: '08:45 AM',
    date: '2024-09-25',
    totalPrice: 201.65,
    status: Status.pending,
  ),
];

List<List<dynamic>> getTestOrdersList(context) {
  return testOrders
      .map(
        (order) => [
          order.clientName,
          order.orderId,
          order.totalPrice.toString(),
          order.buildStatusBadge(context),
        ],
      )
      .toList();
}

List<List<dynamic>> getFullOrdersList(context) {
  return testOrders
      .map(
        (order) => [
          order.clientName,
          order.orderId,
          order.time,
          order.date,
          order.totalPrice.toString(),
          order.buildStatusBadge(context),
        ],
      )
      .toList();
}
