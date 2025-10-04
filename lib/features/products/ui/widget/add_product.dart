import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/app_form_filed.dart';
import 'package:sofian_admin_panel/core/widgets/app_drop_down_menu.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

/// Dialog used to add or edit a product.
/// - set [isEdit] to true when opening to change title/submit label.
class AddProductDialog extends StatefulWidget {
  final bool isEdit;

  const AddProductDialog({super.key, this.isEdit = false});

  @override
  State<AddProductDialog> createState() => _AddProductDialogState();
}

class _AddProductDialogState extends State<AddProductDialog> {
  String? _name;
  String? _price;
  String? _selectedCategory;
  String? _selectedBrand;
  String? _selectedState;

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Static lists until they are fetched from the API
  static const List<String> _categories = [
    'Electronics',
    'Clothing',
    'Home',
    'Beauty',
  ];

  static const List<String> _brands = ['Brand A', 'Brand B', 'Brand C'];

  static const List<String> _states = ['New', 'Used', 'Refurbished'];

  Future<void> _pickImage() async {
    try {
      final XFile? picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      if (picked != null) {
        setState(() {
          _imageFile = File(picked.path);
        });
      }
    } catch (e) {
      // ignore errors for now - in a real app show a snackbar or dialog
    }
  }

  /// Builds the same styled dropdown matching AppFormField exactly.
  Widget _buildStyledDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    double? width,
  }) {
    final uniqueItems = items.toSet().toList();

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: SizedBox(
        width: width ?? 300.w,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(color: Colors.grey.shade300, width: 1.5),
            color: Colors.grey,
          ),
          child: AppDropDownMenu<String>(
            hintText: hintText,
            value: value,
            items: DropdownItemHelper.createStringItems(
              uniqueItems,
              itemStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
            ),
            onChanged: onChanged,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
            inputTextStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
            hintStyle: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: const BorderSide(color: Colors.black),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25.r),
              borderSide: const BorderSide(color: Colors.black),
            ),
            backgroundColor: Colors.white,
          ),
        ),
      ),
    );
  }

  void _submit() {
    // Return a simple map with the filled values. The caller can handle saving.
    Navigator.of(context).pop({
      'name': _name,
      'price': _price,
      'category': _selectedCategory,
      'brand': _selectedBrand,
      'state': _selectedState,
      'image': _imageFile,
      'isEdit': widget.isEdit,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 520.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.isEdit
                          ? AppLocalizations.of(context)!.edit_product
                          : AppLocalizations.of(context)!.add_product,
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
                SizedBox(height: 12.h),

                // Product name
                AppFormField(
                  hintText: AppLocalizations.of(context)!.product_name,
                  onSearchChanged: (value) => _name = value,
                ),

                SizedBox(height: 12.h),

                // Category dropdown
                _buildStyledDropdown(
                  hintText: AppLocalizations.of(context)!.select_category,
                  items: _categories,
                  value: _selectedCategory,
                  onChanged: (v) => setState(() => _selectedCategory = v),
                ),

                SizedBox(height: 12.h),

                // Brand dropdown
                _buildStyledDropdown(
                  hintText: AppLocalizations.of(context)!.select_brand,
                  items: _brands,
                  value: _selectedBrand,
                  onChanged: (v) => setState(() => _selectedBrand = v),
                ),

                SizedBox(height: 12.h),

                // Price + State
                Row(
                  children: [
                    Expanded(
                      child: AppFormField(
                        hintText: AppLocalizations.of(context)!.price,
                        onSearchChanged: (value) => _price = value,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\d*\.?\d*'),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 12.w),
                    _buildStyledDropdown(
                      hintText: AppLocalizations.of(context)!.select_state,
                      items: _states,
                      value: _selectedState,
                      onChanged: (v) => setState(() => _selectedState = v),
                      width: 160.w,
                    ),
                  ],
                ),

                SizedBox(height: 12.h),

                // Image chooser
                Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)!.images,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _pickImage,
                      child: Text(AppLocalizations.of(context)!.choose_image),
                    ),
                  ],
                ),

                SizedBox(height: 8.h),

                if (_imageFile != null)
                  SizedBox(
                    height: 120.h,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8.r),
                      child: Image.file(
                        _imageFile!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),

                SizedBox(height: 18.h),

                Center(
                  child: SizedBox(
                    width: 200,
                    child: AddButton(
                      horizontalPadding: 10,
                      text: widget.isEdit
                          ? AppLocalizations.of(context)!.save
                          : AppLocalizations.of(context)!.add,
                      onTap: _submit,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper to show the dialog and await the result map described in [_submit].
Future<Map<String, dynamic>?> showAddProductDialog(
  BuildContext context, {
  bool isEdit = false,
}) {
  return showDialog<Map<String, dynamic>>(
    context: context,
    barrierDismissible: true,
    builder: (_) => AddProductDialog(isEdit: isEdit),
  );
}
