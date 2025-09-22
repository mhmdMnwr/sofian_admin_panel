import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';

enum Role { superAdmin, admin }

class AdminModel {
  late final String id;
  late final String userName;
  late final List<PermissionsTypes>? permissions;
  late final Role role;

  AdminModel({
    required this.id,
    required this.userName,
    this.permissions = const [PermissionsTypes.orders],
    required this.role,
  });
}
