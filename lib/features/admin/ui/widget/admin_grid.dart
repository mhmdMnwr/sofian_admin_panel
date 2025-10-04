import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/constants.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/features/admin/data/model/admin_model.dart';
import 'package:sofian_admin_panel/features/admin/ui/widget/admin_card.dart';

class AdminGrid extends StatelessWidget {
  final List<AdminModel> admins;

  const AdminGrid({super.key, required this.admins});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Determine number of columns based on screen width
    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 3;
    } else if (screenWidth >= AppConstants.tabletBreakPoint) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

    return Column(
      children: [
        verticalSpace(20),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 20.w,
            mainAxisSpacing: 20.h,
            childAspectRatio: 0.85,
          ),
          itemCount: admins.length,
          itemBuilder: (context, index) {
            return AdminCard(admin: admins[index]);
          },
        ),
      ],
    );
  }
}
