// lib/core/routing/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/features/categories/ui/categories_page.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/dashboard_page.dart';
import 'package:sofian_admin_panel/features/login/ui/responsive_login_page.dart';
import '../layout/main_shell.dart';

/// SIMPLE, ROBUST ROUTER + DUMMY AUTH SERVICE
/// - safe initialLocation ('/login')
/// - centralized route -> permission map
/// - redirect uses `state.subloc` and `startsWith` for nested routes
/// - authService is a ChangeNotifier so GoRouter refreshes when auth changes
///
/// USAGE (during development with dummy data):
///   authService.setCurrentAdmin(yourDummyAdminModel);
///   runApp(MyApp());
///
/// Later, when you have real backend/cubit, replace authService.setCurrentAdmin
/// with real login / fetch logic and notify listeners.

/// Map each route to the permission key expected in AdminModel.permissions.
/// Keep the keys consistent with what you'll store in DB / backend later.
const Map<String, String> routePermissions = {
  '/dashboard': 'dashboard',
  '/categories': 'categories',
  '/products': 'products',
  '/marks': 'marks',
  '/orders': 'orders',
  '/clients': 'clients',
  '/discounts': 'discounts',
  '/users': 'users',
  '/banners': 'banners',
};

/// Simple dummy auth service — replace with real service later.
class DummyAuthService extends ChangeNotifier {
  AdminModel? _currentAdmin;

  AdminModel? get currentAdmin => _currentAdmin;

  /// Set current admin and notify router to refresh redirects.
  void setCurrentAdmin(AdminModel? admin) {
    _currentAdmin = admin;
    notifyListeners();
  }

  bool hasPermissionForBaseRoute(String baseRoute) {
    final admin = _currentAdmin;
    if (admin == null) return false;
    if (admin.role == Role.superAdmin) return true;
    final required = routePermissions[baseRoute];
    if (required == null) return false;
    return admin.permissions?.contains(required) ?? false;
  }

  /// Return first permitted route or a fallback.
  String firstPermittedRouteOrFallback() {
    final admin = _currentAdmin;
    if (admin == null) return '/login';
    if (admin.role == Role.superAdmin) return '/dashboard';
    for (final e in routePermissions.entries) {
      if (admin.permissions?.contains(e.value) ?? false) return e.key;
    }
    // no permissions -> show access denied
    return '/access-denied';
  }
}

final DummyAuthService authService = DummyAuthService();

/// Build the GoRouter. We pass [authService] as refreshListenable so
/// router will re-evaluate redirects when authService.notifyListeners() is called.
final GoRouter appRouter = GoRouter(
  initialLocation: '/login', // safe default
  refreshListenable: authService,
  redirect: (BuildContext context, GoRouterState state) {
    final String requested = state.matchedLocation; // canonical location

    // Always allow login & access-denied pages
    if (requested == '/login' || requested == '/access-denied') {
      return null;
    }

    final admin = authService.currentAdmin;

    // Not logged in -> send to login
    if (admin == null) return '/login';

    // Super admin -> allow everything (redirect /login to dashboard)
    if (admin.role == Role.superAdmin) {
      if (requested == '/login') return '/dashboard';
      return null;
    }

    // Find the base route key that matches requested path (supports nested, e.g. /orders/123)
    final String baseRoute = routePermissions.keys.firstWhere(
      (r) => requested == r || requested.startsWith('$r/'),
      orElse: () => '',
    );

    // If route is not part of the permissions map, allow it (change to deny if desired)
    if (baseRoute.isEmpty) return null;

    // If the admin lacks permission for that base route, redirect
    if (!authService.hasPermissionForBaseRoute(baseRoute)) {
      // Option A: block and show access denied
      return '/access-denied';

      // Option B: redirect to first permitted route instead:
      // return authService.firstPermittedRouteOrFallback();
    }

    // Allowed
    return null;
  },
  routes: <RouteBase>[
    // Public routes (no shell)
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    GoRoute(
      path: '/access-denied',
      builder: (context, state) => const AccessDeniedPage(),
    ),

    // ShellRoute for pages that share the sidebar/layout
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
          builder: (context, state) => const DiscountsPage(),
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

/// ----- Placeholder page widgets (keep your real implementations instead) -----
class ProductPage extends StatelessWidget {
  const ProductPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Products')));
}

class MarksPage extends StatelessWidget {
  const MarksPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Marks')));
}

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Orders')));
}

class DiscountsPage extends StatelessWidget {
  const DiscountsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Discounts')));
}

class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Clients')));
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Users')));
}

class BannersPage extends StatelessWidget {
  const BannersPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const Scaffold(body: Center(child: Text('Banners')));
}

/// Simple Access Denied implementation
class AccessDeniedPage extends StatelessWidget {
  const AccessDeniedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              onPressed: () =>
                  context.go(authService.firstPermittedRouteOrFallback()),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
