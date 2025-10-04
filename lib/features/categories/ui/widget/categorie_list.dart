import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/widgets/generic_table.dart';
import 'package:sofian_admin_panel/features/categories/data/models/category_model.dart';
import 'package:sofian_admin_panel/core/widgets/search_bar.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class CategorieList extends StatefulWidget {
  const CategorieList({super.key});

  @override
  State<CategorieList> createState() => _CategorieListState();
}

class _CategorieListState extends State<CategorieList> {
  late final List<List<dynamic>> categories;

  @override
  void initState() {
    super.initState();
    categories = getCategories();
  }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return GenericTable(
      headers: [
        AppLocalizations.of(context)!.name,
        AppLocalizations.of(context)!.icon,
      ],
      columnWidths: [520.w, 520.w],
      data: categories,
      onDelete: (index) {},
      onEdit: (index) {},
      child: Padding(
        padding: EdgeInsets.only(top: 20.h, left: 20.w),
        child: Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: AppSearchBar(
            width: 400,
            hintText: AppLocalizations.of(context)!.search_for_categories,
          ),
        ),
      ),
    );
  }
}
