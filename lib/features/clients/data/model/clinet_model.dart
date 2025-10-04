// Sample list of Client objects

import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';

List<Client> sampleClients = [
  Client(
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
  Client(
    id: '2',
    name: 'Fatima Ali',
    email: 'fatima.ali@email.com',
    phone: '+20 101 234 5678',
    address: 'Alexandria, Egypt',
    joinDate: '2024-02-20',
    totalSpent: '\$1,850.00',
    ordersCount: '8',
    lastOrderDate: '2024-09-25',
  ),
  Client(
    id: '3',
    name: 'Mohammed Omar',
    email: 'mohammed.omar@email.com',
    phone: '+20 102 345 6789',
    address: 'Giza, Egypt',
    joinDate: '2024-03-10',
    totalSpent: '\$3,200.00',
    ordersCount: '15',
    lastOrderDate: '2024-10-02',
  ),
  Client(
    id: '4',
    name: 'Aisha Mahmoud',
    email: 'aisha.mahmoud@email.com',
    phone: '+20 103 456 7890',
    address: 'Aswan, Egypt',
    joinDate: '2024-01-05',
    totalSpent: '\$1,200.00',
    ordersCount: '6',
    lastOrderDate: '2024-09-15',
  ),
  Client(
    id: '5',
    name: 'Yussef Ibrahim',
    email: 'yussef.ibrahim@email.com',
    phone: '+20 104 567 8901',
    address: 'Luxor, Egypt',
    joinDate: '2024-04-12',
    totalSpent: '\$4,100.00',
    ordersCount: '20',
    lastOrderDate: '2024-10-01',
  ),
  Client(
    id: '6',
    name: 'Nadia Farouk',
    email: 'nadia.farouk@email.com',
    phone: '+20 105 678 9012',
    address: 'Mansoura, Egypt',
    joinDate: '2024-02-28',
    totalSpent: '\$950.00',
    ordersCount: '4',
    lastOrderDate: '2024-09-20',
  ),
  Client(
    id: '7',
    name: 'Karim Saleh',
    email: 'karim.saleh@email.com',
    phone: '+20 106 789 0123',
    address: 'Tanta, Egypt',
    joinDate: '2024-05-18',
    totalSpent: '\$2,800.00',
    ordersCount: '11',
    lastOrderDate: '2024-09-30',
  ),
  Client(
    id: '8',
    name: 'Mona Abdel Rahman',
    email: 'mona.abdel@email.com',
    phone: '+20 107 890 1234',
    address: 'Zagazig, Egypt',
    joinDate: '2024-03-25',
    totalSpent: '\$1,650.00',
    ordersCount: '9',
    lastOrderDate: '2024-09-18',
  ),
];

class Client {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String address;
  final String joinDate;
  final String totalSpent;
  final String ordersCount;
  final String lastOrderDate;

  Client({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.address,
    required this.joinDate,
    required this.totalSpent,
    required this.ordersCount,
    required this.lastOrderDate,
  });
  Widget getOrdersCount(BuildContext context) {
    return Row(
      children: [
        Text(
          ordersCount,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        Image.asset(IconsManager.cart, height: 22, width: 22),
      ],
    );
  }
}

List<List<dynamic>> getTestClinet(BuildContext context) {
  return sampleClients.map((client) {
    return [
      client.name,
      client.phone,
      client.joinDate,
      client.totalSpent,
      client.getOrdersCount(context),
      client.lastOrderDate,
      client.email,
      client.address,
    ];
  }).toList();
}
