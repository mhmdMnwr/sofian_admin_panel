import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';
import 'package:sofian_admin_panel/core/theming/app_icons.dart';
import 'package:sofian_admin_panel/core/theming/styles.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class StatsContainer extends StatelessWidget {
  final String title;
  final double value;
  final String icon;
  final bool isLoss;
  final double pourcentage;
  final double width;

  const StatsContainer({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.isLoss,
    required this.pourcentage,
    this.width = 360,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13.w, horizontal: 16.h),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: _buildColumn(context),
    );
  }

  Widget _buildColumn(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _title(title, context),
            Image.asset(
              icon,
              width: 60.h,
              height: 60.h,
              color: ColorsManager.secondaryBlue,
            ),
          ],
        ),

        _buildValue(context),
      ],
    );
  }

  Widget _buildValue(context) {
    String da = title == AppLocalizations.of(context)!.revenue ? 'DA' : '';

    return Padding(
      padding: EdgeInsets.only(left: 18.w),
      child: Row(
        children: [
          Text(
            '$value'
            ' $da',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(fontSize: 22),
            overflow: TextOverflow.fade,
            maxLines: 2,
          ),
          horizontalSpace(12),
          Flexible(fit: FlexFit.tight, child: _buildGrowth()),
        ],
      ),
    );
  }

  Widget _buildGrowth() {
    String iconPath = isLoss ? IconsManager.loss : IconsManager.growth;
    return Row(
      children: [
        Image.asset(iconPath),
        Text(
          '${pourcentage.toString()}%',
          style: isLoss
              ? TextStyles.font16RedExtraBold.copyWith(fontSize: 14)
              : TextStyles.font16GreenExtraBold.copyWith(fontSize: 14),
        ),
      ],
    );
  }

  Widget _title(String title, context) {
    return Row(
      children: [
        Container(
          height: 30,
          width: 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),

            color: Theme.of(context).textTheme.headlineMedium!.color,
          ),
        ),
        horizontalSpace(10),
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.headlineMedium!.copyWith(fontSize: 22),
        ),
      ],
    );
  }
}
