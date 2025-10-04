import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';

enum Role { superAdmin, admin }

class AdminModel {
  late final String id;
  late final String userName;
  late final String? name;
  late final String? phoneNumber;
  late final String? address;
  late final String? joinDate;
  late final List<PermissionsTypes>? permissions;
  late final Role role;

  AdminModel({
    required this.id,
    required this.userName,
    this.name,
    this.phoneNumber,
    this.address,
    this.joinDate,
    this.permissions = const [PermissionsTypes.orders],
    required this.role,
  });
}

// Sample admin data for testing
List<AdminModel> sampleAdmins = [
  AdminModel(
    id: '1',
    userName: 'admin01',
    name: 'Ameur mohammed Mnaouor',
    phoneNumber: '0612589666',
    address: 'Rue Zone 17, mascara',
    joinDate: '18 September 2025',
    role: Role.admin,
    permissions: [PermissionsTypes.products, PermissionsTypes.categories],
  ),
  AdminModel(
    id: '2',
    userName: 'admin02',
    name: 'Ahmed Hassan',
    phoneNumber: '0555123456',
    address: 'Street 10, Algiers',
    joinDate: '15 August 2025',
    role: Role.admin,
    permissions: [
      PermissionsTypes.orders,
      PermissionsTypes.clients,
      PermissionsTypes.products,
    ],
  ),
  AdminModel(
    id: '3',
    userName: 'admin03',
    name: 'Fatima Zahra',
    phoneNumber: '0666789012',
    address: 'Boulevard Mohammed V, Oran',
    joinDate: '20 July 2025',
    role: Role.admin,
    permissions: [
      PermissionsTypes.categories,
      PermissionsTypes.products,
      PermissionsTypes.brands,
      PermissionsTypes.discounts,
    ],
  ),
  AdminModel(
    id: '4',
    userName: 'admin04',
    name: 'Youssef Benali',
    phoneNumber: '0777345678',
    address: 'Rue des Frères, Constantine',
    joinDate: '5 June 2025',
    role: Role.admin,
    permissions: [PermissionsTypes.orders, PermissionsTypes.clients],
  ),
  AdminModel(
    id: '5',
    userName: 'admin05',
    name: 'Salma Mansouri',
    phoneNumber: '0698456789',
    address: 'Quartier El Houria, Annaba',
    joinDate: '10 September 2025',
    role: Role.admin,
    permissions: [
      PermissionsTypes.products,
      PermissionsTypes.brands,
      PermissionsTypes.banners,
    ],
  ),
  AdminModel(
    id: '6',
    userName: 'superadmin',
    name: 'Super Admin',
    phoneNumber: '0550000000',
    address: 'Main Office, Algiers',
    joinDate: '1 January 2025',
    role: Role.superAdmin,
    permissions: [],
  ),
];
