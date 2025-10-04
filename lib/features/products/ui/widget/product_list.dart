import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/widgets/generic_table.dart';
import 'package:sofian_admin_panel/core/widgets/search_bar.dart';
import 'package:sofian_admin_panel/features/products/data/model/prduct_model.dart'
    show getProductsData;
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class ProductList extends StatefulWidget {
  const ProductList({super.key});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  // late final List<List<dynamic>> products;

  // @override
  // void initState() {
  //   super.initState();
  //   products = getProductsData(context);
  // }

  @override
  Widget build(BuildContext context) {
    bool isRtl = Directionality.of(context) == TextDirection.rtl;

    return GenericTable(
      headers: [
        AppLocalizations.of(context)!.product_id,
        AppLocalizations.of(context)!.image,
        AppLocalizations.of(context)!.name,
        AppLocalizations.of(context)!.categorie,
        AppLocalizations.of(context)!.brand,
        AppLocalizations.of(context)!.price,
        AppLocalizations.of(context)!.status,
      ],
      data: getProductsData(context),
      onDelete: (index) {},
      onEdit: (index) {},
      child: Padding(
        padding: EdgeInsets.only(top: 20.h, left: 20.w),
        child: Align(
          alignment: isRtl ? Alignment.centerRight : Alignment.centerLeft,
          child: AppSearchBar(
            width: 400,
            hintText: AppLocalizations.of(context)!.search_for_products,
          ),
        ),
      ),
    );
  }
}
