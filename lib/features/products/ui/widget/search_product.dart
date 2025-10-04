import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sofian_admin_panel/core/helpers/spacing.dart';
import 'package:sofian_admin_panel/core/widgets/app_drop_down_menu.dart';
import 'package:sofian_admin_panel/core/widgets/search_bar.dart';

class SearchProduct extends StatefulWidget {
  final Function(String)? onSearchChanged;
  final Function(String?)? onBrandChanged;
  final Function(String?)? onStateChanged;
  final Function(String?)? onCategoryChanged;
  final String? searchHint;
  final String? brandHint;
  final String? stateHint;
  final String? categoryHint;
  final List<String> brands;
  final List<String> categories;
  final List<String> states;

  const SearchProduct({
    super.key,
    this.onSearchChanged,
    this.onBrandChanged,
    this.onStateChanged,
    this.onCategoryChanged,
    this.searchHint,
    this.brandHint,
    this.stateHint,
    this.categoryHint,
    required this.brands,
    required this.categories,
    required this.states,
  });

  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {
  final TextEditingController _searchController = TextEditingController();
  String? selectedBrand;
  String? selectedState;
  String? selectedCategory;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
      if (widget.onSearchChanged != null) {
        widget.onSearchChanged!(_searchController.text);
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchField() {
    return AppSearchBar(
      hintText: widget.searchHint ?? 'Search for products...',
      onSearchChanged: widget.onSearchChanged,
    );
  }

  /// Builds a reusable dropdown widget with common styling.
  /// width must be provided to avoid Flexible/Expanded being used implicitly.
  Widget _buildDropdown({
    required String hintText,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required double width,
  }) {
    // Remove duplicates from items list to prevent the assertion error
    final uniqueItems = items.toSet().toList();
    
    // Add "All" option at the beginning to reset the dropdown
    final itemsWithAll = ['All', ...uniqueItems];

    // Ensure the value is null if it's not in the items list or if it's "All"
    final validValue = value != null && itemsWithAll.contains(value) && value != 'All'
        ? value
        : null;

    final dropdownWidget = Container(
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
        color: Colors.white,
      ),
      child: Center(
        child: AppDropDownMenu<String>(
          hintText: hintText,
          value: validValue,
          items: DropdownItemHelper.createStringItems(
            itemsWithAll,
            itemStyle: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
          onChanged: (newValue) {
            // If "All" is selected, pass null to reset the dropdown
            if (newValue == 'All') {
              onChanged(null);
            } else {
              onChanged(newValue);
            }
          },
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
          inputTextStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(25.r),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );

    // Force explicit width to keep layout stable
    return SizedBox(width: width, child: dropdownWidget);
  }

  Widget _buildBrandDropdown({required double width}) {
    return _buildDropdown(
      hintText: widget.brandHint ?? 'Brand',
      value: selectedBrand,
      items: widget.brands,
      width: width,
      onChanged: (value) {
        setState(() {
          selectedBrand = value;
        });
        if (widget.onBrandChanged != null) {
          widget.onBrandChanged!(value);
        }
      },
    );
  }

  Widget _buildStateDropdown({required double width}) {
    return _buildDropdown(
      hintText: widget.stateHint ?? 'State',
      value: selectedState,
      items: widget.states,
      width: width,
      onChanged: (value) {
        setState(() {
          selectedState = value;
        });
        if (widget.onStateChanged != null) {
          widget.onStateChanged!(value);
        }
      },
    );
  }

  Widget _buildCategoryDropdown({required double width}) {
    return _buildDropdown(
      hintText: widget.categoryHint ?? 'Category',
      value: selectedCategory,
      items: widget.categories,
      width: width,
      onChanged: (value) {
        setState(() {
          selectedCategory = value;
        });
        if (widget.onCategoryChanged != null) {
          widget.onCategoryChanged!(value);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // handle unbounded constraints by falling back to MediaQuery
        final double availableWidth = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : MediaQuery.of(context).size.width;

        final isNarrow = availableWidth < 700;

        // compute a sensible dropdown width based on available width
        final double horizontalPadding = 16.w * 2;
        final double gaps = 8.w * 2; // two gaps between three dropdowns
        final rawDropdownWidth =
            (availableWidth - horizontalPadding - gaps) / 3.0;

        // clamp to sensible min/max and guard if rawDropdownWidth is not finite
        final double minW = 80;
        final double maxW = 260;
        final double dropdownWidth = rawDropdownWidth.isFinite
            ? math.max(minW, math.min(maxW, rawDropdownWidth))
            : 160.w;

        return Padding(
          padding: EdgeInsets.all(16.w),
          child: isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSearchField(),
                    SizedBox(height: 12.h),
                    // Wrap so dropdowns wrap rather than overflow
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 8.h,
                      children: [
                        _buildBrandDropdown(width: dropdownWidth),
                        _buildStateDropdown(width: dropdownWidth),
                        _buildCategoryDropdown(width: dropdownWidth),
                      ],
                    ),
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: _buildSearchField()),
                    horizontalSpace(12),
                    _buildBrandDropdown(width: 200.w),
                    horizontalSpace(12),
                    _buildStateDropdown(width: 160.w),
                    horizontalSpace(12),
                    _buildCategoryDropdown(width: 200.w),
                  ],
                ),
        );
      },
    );
  }

  // Method to clear all filters
  void clearAllFilters() {
    setState(() {
      _searchController.clear();
      selectedBrand = null;
      selectedState = null;
      selectedCategory = null;
      _searchQuery = '';
    });
  }

  // Method to get current filter values
  Map<String, dynamic> getCurrentFilters() {
    return {
      'search': _searchQuery,
      'brand': selectedBrand,
      'state': selectedState,
      'category': selectedCategory,
    };
  }

  // Method to collect all filter data for API requests
  Map<String, dynamic> getFilterData({bool includeNullValues = false}) {
    final Map<String, dynamic> filterData = {};

    if (_searchQuery.isNotEmpty) {
      filterData['search'] = _searchQuery;
    }

    if (selectedBrand != null || includeNullValues) {
      filterData['brand'] = selectedBrand;
    }

    if (selectedState != null || includeNullValues) {
      filterData['state'] = selectedState;
    }

    if (selectedCategory != null || includeNullValues) {
      filterData['category'] = selectedCategory;
    }

    return filterData;
  }

  // Method to get only active (non-null) filters
  Map<String, String> getActiveFilters() {
    final Map<String, String> activeFilters = {};

    if (_searchQuery.isNotEmpty) {
      activeFilters['search'] = _searchQuery;
    }

    if (selectedBrand != null) {
      activeFilters['brand'] = selectedBrand!;
    }

    if (selectedState != null) {
      activeFilters['state'] = selectedState!;
    }

    if (selectedCategory != null) {
      activeFilters['category'] = selectedCategory!;
    }

    return activeFilters;
  }

  // Method to check if any filters are applied
  bool get hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        selectedBrand != null ||
        selectedState != null ||
        selectedCategory != null;
  }
}
