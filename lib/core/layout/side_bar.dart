import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sofian_admin_panel/core/routing/routes.dart';
import 'package:sofian_admin_panel/core/theming/cubit/theme_cubit.dart';

class Sidebar extends StatefulWidget {
  final String initialPage;
  const Sidebar({super.key, this.initialPage =Routes.dashboard});

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late String currentPage;

  @override
  void initState() {
    super.initState();
    currentPage = widget.initialPage;
  }

  void _navigate(String page) {
    setState(() {
      currentPage = page;
    });
    // Add navigation logic here, e.g. using Navigator or a callback
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    IconData changeThemeIcon = Theme.of(context).brightness == Brightness.dark
      ? Icons.light_mode
      : Icons.dark_mode;

    return Container(
      width: 250,
      color: theme.colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 100,
            color: theme.colorScheme.primary,
            child: Center(
              child: Text(
                'My App',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
          _buildMenuItem(context, Icons.dashboard, 'Dashboard', 'dashboard'),
          _buildMenuItem(context, Icons.shopping_cart, 'Products', 'products'),
          const Spacer(),
          const Divider(),
          ListTile(
            leading:  Icon(changeThemeIcon),
            title: const Text('Toggle Theme'),
            onTap: () {context.read<ThemeCubit>().toggleTheme(); 
            setState(() {
              
            });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, String page) {
    final theme = Theme.of(context);
    final isActive = page == currentPage;

    return InkWell(
      onTap: () => _navigate(page),
      child: Container(
        color: isActive ? theme.colorScheme.primary.withOpacity(0.1) : Colors.transparent,
        child: ListTile(
          leading: Icon(icon, color: isActive ? theme.colorScheme.primary : theme.iconTheme.color),
          title: Text(
            title,
            style: TextStyle(
              color: isActive ? theme.colorScheme.primary : theme.colorScheme.onBackground,
            ),
          ),
        ),
      ),
    );
  }
}
