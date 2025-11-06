import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/app_form_filed.dart';
import 'package:sofian_admin_panel/core/widgets/drop_down_list.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class AddBrand extends StatefulWidget {
  final bool isEdit;
  const AddBrand({super.key, this.isEdit = false});

  @override
  State<AddBrand> createState() => _AddBrandState();
}

class _AddBrandState extends State<AddBrand> {
  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Builder(
        builder: (dialogContext) {
          return Container(
            constraints: BoxConstraints(maxWidth: 500),
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEdit ? loc.edit_brand : loc.add_brand,
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.close),
                    ),
                  ],
                ),
                verticalSpace(12.h),
                AppFormField(
                  hintText: loc.brand_name,
                  onSearchChanged: (value) {},
                  width: 400,
                ),
                verticalSpace(24.h),
                BuildStyledDropdown(
                  hintText: AppLocalizations.of(context)!.select_state,
                  items: ['Active', 'Inactive'],
                  value: ['Active', 'Inactive'].first,
                  onChanged: (v) {},
                ),

                verticalSpace(64),

                Center(
                  child: SizedBox(
                    width: 200,
                    child: AppButton(
                      horizontalPadding: 10,
                      text: widget.isEdit
                          ? AppLocalizations.of(context)!.save
                          : AppLocalizations.of(context)!.add,
                      onTap: () {},
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

Future<Map<String, dynamic>?> showAddCategoryDialog(
  BuildContext context, {
  bool isEdit = false,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    builder: (_) => AddBrand(isEdit: isEdit),
  );
}
