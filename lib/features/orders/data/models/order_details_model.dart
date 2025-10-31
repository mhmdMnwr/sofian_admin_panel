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
  int? boxesQuantity;
  double? unitesQuantity;
  double? price;
  int? unitPerBox;
  OrderProducts({
    this.productName,
    this.boxesQuantity,
    this.unitesQuantity,
    this.price,
    this.unitPerBox,
  });
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
    // Product with boxes: 2 boxes × 10 units/box + 3 rest = 23 units
    OrderProducts(
      productName: 'Product A (Boxed Items)',
      boxesQuantity: 2,
      unitesQuantity: 3.0,
      price: 5.00,
      unitPerBox: 10,
    ),
    // Product with boxes: 1 box × 6 units/box + 0 rest = 6 units
    OrderProducts(
      productName: 'Product B (Full Box)',
      boxesQuantity: 1,
      unitesQuantity: 0.0,
      price: 12.00,
      unitPerBox: 6,
    ),
    // Weight product: 2.5 kg (double value)
    OrderProducts(
      productName: 'Product C (By Weight)',
      boxesQuantity: 0,
      unitesQuantity: 2.5,
      price: 15.00,
      unitPerBox: 1,
    ),
    // Weight product: 1.75 kg
    OrderProducts(
      productName: 'Product D (Cheese)',
      boxesQuantity: 0,
      unitesQuantity: 1.75,
      price: 20.00,
      unitPerBox: 1,
    ),
    // Product with boxes: 3 boxes × 12 units/box + 5 rest = 41 units
    OrderProducts(
      productName: 'Product E (Mixed)',
      boxesQuantity: 3,
      unitesQuantity: 5.0,
      price: 3.50,
      unitPerBox: 12,
    ),
  ],
  status: Status.pending,
);
