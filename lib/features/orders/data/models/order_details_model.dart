import 'package:sofian_admin_panel/features/clients/data/model/clinet_model.dart';
import 'package:sofian_admin_panel/features/orders/data/models/order_model.dart';

class OrderDetailsModel {
  final String? orderId;
  final Client? client;
  final String? date;
  final String? time;
  final double? totalPrice;
  final List<OrderProducts>? orderProducts;
  final Status? status;

  OrderDetailsModel({
    this.orderId,
    this.client,
    this.date,
    this.time,
    this.totalPrice,
    this.orderProducts,
    this.status,
  });
}

class OrderProducts {
  String? productName;
  int? quantity;
  double? price;

  OrderProducts({this.productName, this.quantity, this.price});
}
