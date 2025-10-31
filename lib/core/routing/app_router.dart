import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/core/routing/routes.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/features/admin/ui/admins_page.dart';
import 'package:sofian_admin_panel/features/brands/ui/brands_page.dart';
import 'package:sofian_admin_panel/features/categories/ui/categories_page.dart';
import 'package:sofian_admin_panel/features/clients/ui/clinets_page.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/dashboard_page.dart';
import 'package:sofian_admin_panel/features/login/ui/login_page.dart';
import 'package:sofian_admin_panel/features/orders/ui/orders_page.dart';
import 'package:sofian_admin_panel/features/products/ui/products_page.dart';
import '../layout/main_shell.dart';

final routePermissions = {
  Routes.dashboard: PermissionsTypes.dashboard,
  Routes.categories: PermissionsTypes.categories,
  Routes.products: PermissionsTypes.products,
  Routes.brands: PermissionsTypes.brands,
  Routes.orders: PermissionsTypes.orders,
  Routes.clients: PermissionsTypes.clients,
  Routes.discounts: PermissionsTypes.discounts,
  Routes.users: PermissionsTypes.users,
  Routes.banners: PermissionsTypes.banners,
};

// Helper function to check if user has permission for a specific route
bool _hasPermissionForRoute(String route) {
  // Get current admin (you can replace this with your state management solution)
  final currentAdmin =
      superAdmin; // Replace with your actual current admin logic from main_shell.dart

  // SuperAdmin has access to everything
  if (currentAdmin.role == Role.superAdmin) {
    return true;
  }

  // Map routes to required permissions

  final requiredPermission = routePermissions[route];
  if (requiredPermission == null) return false;

  return currentAdmin.permissions?.contains(requiredPermission) ?? false;
}

// Helper function to get the first permitted route for a user
String _getFirstPermittedRoute() {
  final currentAdmin =
      superAdmin; // Replace with your actual current admin logic

  // SuperAdmin gets first route (dashboard)
  if (currentAdmin.role == Role.superAdmin) {
    return '/dashboard';
  }

  // Find first route user has permission for
  for (final entry in routePermissions.entries) {
    if (currentAdmin.permissions?.contains(entry.value) ?? false) {
      return entry.key;
    }
  }

  // No permissions found, redirect to login
  return '/login';
}

final appRouter = GoRouter(
  initialLocation: _getFirstPermittedRoute(),
  redirect: (context, state) {
    final requestedPath = state.uri.path;

    // Allow login and access denied pages
    if (requestedPath == Routes.login || requestedPath == Routes.accessDenied) {
      return null;
    }

    // Check permission for requested route
    if (!_hasPermissionForRoute(requestedPath)) {
      // Option 1: Redirect to access denied page
      return Routes.accessDenied;

      // Option 2: Redirect to first permitted page (uncomment line below and comment line above)
      // return _getFirstPermittedRoute();
    }

    return null; // Allow navigation
  },
  routes: [
    // Login route outside the ShellRoute
    GoRoute(path: Routes.login, builder: (context, state) => const LoginPage()),

    // Access denied route outside the ShellRoute
    GoRoute(
      path: Routes.accessDenied,
      builder: (context, state) => const AccessDeniedPage(),
    ),

    // Routes that need the sidebar
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: Routes.dashboard,
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: Routes.categories,
          builder: (context, state) => const CategoriesPage(),
        ),
        GoRoute(
          path: Routes.products,
          builder: (context, state) => const ProductsPage(),
        ),
        GoRoute(
          path: Routes.brands,
          builder: (context, state) => const BrandsPage(),
        ),
        GoRoute(
          path: Routes.orders,
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: Routes.discounts,
          builder: (context, state) => const Discounts(),
        ),
        GoRoute(
          path: Routes.clients,
          builder: (context, state) => const ClientsPage(),
        ),
        GoRoute(
          path: Routes.admins,
          builder: (context, state) => const AdminsPage(),
        ),
        GoRoute(
          path: Routes.banners,
          builder: (context, state) => const BannersPage(),
        ),
      ],
    ),
  ],
);

// Placeholder pages

class Discounts extends StatelessWidget {
  const Discounts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Discounts Page')));
  }
}

class BannersPage extends StatelessWidget {
  const BannersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Banners Page')));
  }
}

class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 64, color: Colors.red),
            verticalSpace(16),
            Text(
              'Access Denied',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            verticalSpace(8),
            Text('You do not have permission to access this page.'),
            verticalSpace(16),
            ElevatedButton(
              onPressed: () => context.go(_getFirstPermittedRoute()),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
