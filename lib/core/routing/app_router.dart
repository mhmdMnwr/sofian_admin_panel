import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sofian_admin_panel/core/layout/sidebar_page_model.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/features/categories/ui/categories_page.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/dashboard_page.dart';
import 'package:sofian_admin_panel/features/login/ui/login_page.dart';
import '../layout/main_shell.dart';

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
  final routePermissions = {
    '/dashboard': PermissionsTypes.dashboard,
    '/categories': PermissionsTypes.categories,
    '/products': PermissionsTypes.products,
    '/marks': PermissionsTypes.marks,
    '/orders': PermissionsTypes.orders,
    '/clients': PermissionsTypes.clients,
    '/discounts': PermissionsTypes.discounts,
    '/users': PermissionsTypes.users,
    '/banners': PermissionsTypes.banners,
  };

  final requiredPermission = routePermissions[route];
  if (requiredPermission == null) return false;

  return currentAdmin.permissions?.contains(requiredPermission) ?? false;
}

// Helper function to get the first permitted route for a user
String _getFirstPermittedRoute() {
  final currentAdmin =
      superAdmin; // Replace with your actual current admin logic

  final routePermissions = {
    '/dashboard': PermissionsTypes.dashboard,
    '/categories': PermissionsTypes.categories,
    '/products': PermissionsTypes.products,
    '/marks': PermissionsTypes.marks,
    '/orders': PermissionsTypes.orders,
    '/clients': PermissionsTypes.clients,
    '/discounts': PermissionsTypes.discounts,
    '/users': PermissionsTypes.users,
    '/banners': PermissionsTypes.banners,
  };

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
    if (requestedPath == '/login' || requestedPath == '/access-denied') {
      return null;
    }

    // Check permission for requested route
    if (!_hasPermissionForRoute(requestedPath)) {
      // Option 1: Redirect to access denied page
      return '/access-denied';

      // Option 2: Redirect to first permitted page (uncomment line below and comment line above)
      // return _getFirstPermittedRoute();
    }

    return null; // Allow navigation
  },
  routes: [
    // Login route outside the ShellRoute
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

    // Access denied route outside the ShellRoute
    GoRoute(
      path: '/access-denied',
      builder: (context, state) => const AccessDeniedPage(),
    ),

    // Routes that need the sidebar
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesPage(),
        ),
        GoRoute(
          path: '/products',
          builder: (context, state) => const ProductPage(),
        ),
        GoRoute(path: '/marks', builder: (context, state) => const MarksPage()),
        GoRoute(
          path: '/orders',
          builder: (context, state) => const OrdersPage(),
        ),
        GoRoute(
          path: '/discounts',
          builder: (context, state) => const Discounts(),
        ),
        GoRoute(
          path: '/clients',
          builder: (context, state) => const ClientsPage(),
        ),
        GoRoute(path: '/users', builder: (context, state) => const UsersPage()),
        GoRoute(
          path: '/banners',
          builder: (context, state) => const BannersPage(),
        ),
      ],
    ),
  ],
);

// Placeholder pages
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Products Page')));
  }
}

class MarksPage extends StatelessWidget {
  const MarksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Marks Page')));
  }
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Orders Page')));
  }
}

class Discounts extends StatelessWidget {
  const Discounts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Discounts Page')));
  }
}

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Clients Page')));
  }
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text('Users Page')));
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
            const SizedBox(height: 16),
            const Text(
              'Access Denied',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('You do not have permission to access this page.'),
            const SizedBox(height: 16),
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
