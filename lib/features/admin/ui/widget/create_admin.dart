import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/add_button.dart';
import 'package:sofian_admin_panel/core/widgets/alert_dialog.dart';
import 'package:sofian_admin_panel/core/widgets/app_form_filed.dart';
import 'package:sofian_admin_panel/l10n/app_localizations.dart';

class AddSubAdminDialog extends StatefulWidget {
  const AddSubAdminDialog({super.key});

  @override
  State<AddSubAdminDialog> createState() => _AddSubAdminDialogState();
}

class _AddSubAdminDialogState extends State<AddSubAdminDialog> {
  final Map<String, bool> selectedSections = {};
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // We'll fill this in didChangeDependencies where context/localization is available
  List<String> _sections = [];
  bool _didInitLocalizations = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_didInitLocalizations) {
      final loc = AppLocalizations.of(context)!;

      // build the sections list from localization
      _sections = [
        loc.dashboard,
        loc.categories,
        loc.products,
        loc.brands,
        loc.orders,
        loc.clients,
        loc.discounts,
        loc.banners,
      ];

      // initialize selectedSections map
      for (var section in _sections) {
        selectedSections.putIfAbsent(section, () => false);
      }

      _didInitLocalizations = true;
    }
  }

  void _submit() => showAppAlertDialog(
    context: context,
    title: AppLocalizations.of(context)!.confirmation,
    content: AppLocalizations.of(
      context,
    )!.are_you_sure_you_want_to_add_this_admin,
    primaryButtonText: AppLocalizations.of(context)!.confirm,
    secondaryButtonText: AppLocalizations.of(context)!.cancel,
    onPrimaryButtonTap: () {
      // Handle admin creation logic here
      Navigator.of(context).pop(); // Close confirmation dialog
      Navigator.of(context).pop(); // Close add admin dialog
    },
    onSecondaryButtonTap: () {
      Navigator.of(context).pop(); // Close confirmation dialog
    },
  );

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final ThemeData theme = Theme.of(context);
    return Center(
      child: Dialog(
        backgroundColor: theme.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600.w),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                /// Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      // consider adding this key to your localization files
                      loc.add_admin,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                verticalSpace(16.h),

                /// Form Fields
                // If your AppFormField supports a controller and obscureText param,
                // prefer passing controller: nameController etc.
                AppFormField(
                  hintText: loc.name, // use localized hint
                  onSearchChanged: (v) => nameController.text = v,
                ),
                verticalSpace(12),
                AppFormField(
                  hintText: loc.phone_number,
                  keyboardType: TextInputType.phone,
                  onSearchChanged: (v) => phoneController.text = v,
                ),
                verticalSpace(12),
                AppFormField(
                  hintText: loc.address,
                  onSearchChanged: (v) => addressController.text = v,
                ),
                verticalSpace(12),

                // Password field — if AppFormField supports obscureText and controller:
                AppFormField(
                  hintText: loc.password,
                  onSearchChanged: (v) => passwordController.text = v,
                  obscureText: true,
                ),

                // If AppFormField does NOT support obscureText, use native TextFormField:
                // TextFormField(
                //   controller: passwordController,
                //   obscureText: true,
                //   decoration: InputDecoration(hintText: loc.password),
                // ),
                verticalSpace(20.h),

                /// Section Selector
                Align(
                  alignment:
                      Localizations.localeOf(context).languageCode == 'ar'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Text(
                    loc.selectAssignedSections,
                    style: theme.textTheme.bodyMedium!.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                verticalSpace(10.h),

                Wrap(
                  spacing: 24.w,
                  runSpacing: 8.h,
                  children: _sections.map((section) {
                    final isSelected = selectedSections[section] ?? false;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedSections[section] =
                              !(selectedSections[section] ?? false);
                        });
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Checkbox(
                            value: isSelected,
                            onChanged: (value) {
                              setState(() {
                                selectedSections[section] = value ?? false;
                              });
                            },
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            section,
                            style: theme.textTheme.bodyMedium!.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                verticalSpace(24.h),

                /// Add Button
                Center(
                  child: SizedBox(
                    width: 120,
                    child: AddButton(
                      horizontalPadding: 0,
                      onTap: _submit,
                      text: loc.add,
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

void showCreateAdminDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return const AddSubAdminDialog();
    },
  );
}
