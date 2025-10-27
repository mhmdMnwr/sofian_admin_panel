import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/widgets/app_form_filed.dart';

//TODO this ui is not centered and i should use the appbutton and the permissions list  and the applocalizations for language and icons for the persmissions and the password field
class AddSubAdminDialog extends StatefulWidget {
  const AddSubAdminDialog({super.key});

  @override
  State<AddSubAdminDialog> createState() => _AddSubAdminDialogState();
}

class _AddSubAdminDialogState extends State<AddSubAdminDialog> {
  final List<String> sections = [
    'Categories',
    'Products',
    'Brands',
    'Orders',
    'Banners',
    'Promotions',
  ];

  final Map<String, bool> selectedSections = {};
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    for (var section in sections) {
      selectedSections[section] = false;
    }
  }

  void _submit() {
    // Example submission logic
    final selected = selectedSections.entries
        .where((e) => e.value)
        .map((e) => e.key)
        .toList();

    // TODO: send to backend / cubit / repository
    debugPrint('Name: ${nameController.text}');
    debugPrint('Phone: ${phoneController.text}');
    debugPrint('Address: ${addressController.text}');
    debugPrint('Selected Sections: $selected');

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add a Sub - Admin',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              SizedBox(height: 16.h),

              /// Form Fields
              AppFormField(
                hintText: 'Name',
                onSearchChanged: (v) => nameController.text = v,
              ),
              SizedBox(height: 12.h),
              AppFormField(
                hintText: 'Phone Number',
                keyboardType: TextInputType.phone,
                onSearchChanged: (v) => phoneController.text = v,
              ),
              SizedBox(height: 12.h),
              AppFormField(
                hintText: 'Address',
                onSearchChanged: (v) => addressController.text = v,
              ),
              SizedBox(height: 20.h),

              /// Section Selector
              Text(
                'Select assigned sections',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
              ),
              SizedBox(height: 10.h),

              Wrap(
                spacing: 40.w,
                runSpacing: 8.h,
                children: sections.map((section) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: selectedSections[section],
                        onChanged: (value) {
                          setState(() {
                            selectedSections[section] = value ?? false;
                          });
                        },
                      ),
                      Text(section, style: TextStyle(fontSize: 14.sp)),
                    ],
                  );
                }).toList(),
              ),

              SizedBox(height: 24.h),

              /// Add Button
              Center(
                child: SizedBox(
                  width: 180.w,
                  height: 42.h,
                  child: FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text('Add'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

showCreateAdminDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AddSubAdminDialog();
    },
  );
}
