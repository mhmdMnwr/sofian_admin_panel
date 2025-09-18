import 'package:go_router/go_router.dart';
import 'package:sofian_admin_panel/features/categories/ui/categories_page.dart';
import 'package:sofian_admin_panel/features/dashboard/ui/dashboard_page.dart';
import 'package:sofian_admin_panel/features/login/ui/login_page.dart';

import '../layout/main_shell.dart';

final appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    // Login route outside the ShellRoute
    GoRoute(path: '/login', builder: (context, state) => const LoginPage()),

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
      ],
    ),
  ],
);
