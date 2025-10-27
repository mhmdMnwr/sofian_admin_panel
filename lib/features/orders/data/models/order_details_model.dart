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

// Test object for OrderDetailsModel
final testOrderDetails = OrderDetailsModel(
  orderId: 'ORD-12345',
  client: Client(
    id: '1',
    name: 'Ahmed Hassan',
    email: 'ahmed.hassan@email.com',
    phone: '+20 100 123 4567',
    address: 'Cairo, Egypt',
    joinDate: '2024-01-15',
    totalSpent: '\$2,450.00',
    ordersCount: '12',
    lastOrderDate: '2024-09-28',
  ),
  date: '2024-10-22',
  time: '14:30',
  totalPrice: 450.00,
  orderProducts: [
    OrderProducts(productName: 'Product A', quantity: 2, price: 150.00),
    OrderProducts(productName: 'Product B', quantity: 1, price: 150.00),
  ],
  status: Status.pending,
);
