import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/layout/side_bar.dart';

class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideBar(),
          Expanded(
            child: Container(color: Colors.grey[100], child: child),
          ),
        ],
      ),
    );
  }
}
