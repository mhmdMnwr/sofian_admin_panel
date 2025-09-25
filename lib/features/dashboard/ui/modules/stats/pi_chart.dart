// import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:sofian_admin_panel/core/data/chart_data_table.dart';
// import 'package:sofian_admin_panel/core/helpers/spacing.dart';

// /// Pie Chart Widget for Top Selling Products in Grocery Shop
// ///
// /// Features:
// /// - Shows top selling products with customizable count (5, 10, 20, 30)
// /// - Interactive pie chart with hover effects
// /// - Product details list with sales amounts and units sold
// /// - Category-based color coding (Dairy, Drinks, Snacks, Frozen)
// /// - Percentage breakdown for each product and category
// /// - Real-time data filtering based on selected product count
// ///
// /// Grocery Categories:
// /// - Dairy: Yogurts, Milk, Cheese, Butter (Green)
// /// - Drinks: Soda, Juice, Water, Coffee (Blue)
// /// - Snacks: Chips, Cookies, Crackers, Nuts (Orange)
// /// - Frozen: Ice Cream, Pizza, Vegetables, Berries (Purple)

// class TopSellingProductsPieChart extends StatefulWidget {
//   const TopSellingProductsPieChart({super.key});

//   @override
//   State<TopSellingProductsPieChart> createState() =>
//       _TopSellingProductsPieChartState();
// }

// class _TopSellingProductsPieChartState
//     extends State<TopSellingProductsPieChart> {
//   int selectedProductCount = 5; // Default to top 5 products
//   int touchedIndex = -1;

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(16.w),
//       decoration: BoxDecoration(
//         color: Theme.of(context).primaryColor,
//         borderRadius: BorderRadius.circular(12.r),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.05),
//             blurRadius: 10,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           _buildHeader(),
//           verticalSpace(20),
//           _buildChart(),
//           verticalSpace(20),
//           _buildLegend(),
//         ],
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Row(
//       children: [
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'Top Selling Products',
//                 style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
//               ),
//               verticalSpace(4),
//               Text(
//                 'Sales by product category',
//                 style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
//               ),
//             ],
//           ),
//         ),
//         _buildProductCountDropdown(),
//       ],
//     );
//   }

//   Widget _buildProductCountDropdown() {
//     final options = [5, 10, 20, 30];

//     return Container(
//       padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(6.r),
//       ),
//       child: DropdownButton<int>(
//         value: selectedProductCount,
//         underline: const SizedBox(),
//         items: options
//             .map(
//               (int value) => DropdownMenuItem<int>(
//                 value: value,
//                 child: Text('Top $value', style: TextStyle(fontSize: 12.sp)),
//               ),
//             )
//             .toList(),
//         onChanged: (int? newValue) {
//           if (newValue != null) {
//             setState(() {
//               selectedProductCount = newValue;
//               touchedIndex = -1; // Reset touched index
//             });
//           }
//         },
//       ),
//     );
//   }

//   Widget _buildChart() {
//     final pieChartSections = TopProductsTable.getPieChartSections(
//       selectedProductCount,
//     );

//     return SizedBox(
//       height: 300.h,
//       child: Row(
//         children: [
//           // Pie Chart
//           Expanded(
//             flex: 3,
//             child: PieChart(
//               PieChartData(
//                 pieTouchData: PieTouchData(
//                   touchCallback: (FlTouchEvent event, pieTouchResponse) {
//                     setState(() {
//                       if (!event.isInterestedForInteractions ||
//                           pieTouchResponse == null ||
//                           pieTouchResponse.touchedSection == null) {
//                         touchedIndex = -1;
//                         return;
//                       }
//                       touchedIndex =
//                           pieTouchResponse.touchedSection!.touchedSectionIndex;
//                     });
//                   },
//                 ),
//                 borderData: FlBorderData(show: false),
//                 sectionsSpace: 0,
//                 centerSpaceRadius: 40,
//                 sections: pieChartSections.asMap().entries.map((entry) {
//                   final index = entry.key;
//                   final section = entry.value;
//                   final isTouched = index == touchedIndex;
//                   final fontSize = isTouched ? 14.sp : 12.sp;
//                   final radius = isTouched ? 70.0 : 60.0;

//                   return PieChartSectionData(
//                     color: section.color,
//                     value: section.value,
//                     title: section.title,
//                     radius: radius,
//                     titleStyle: TextStyle(
//                       fontSize: fontSize,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.white,
//                     ),
//                   );
//                 }).toList(),
//               ),
//             ),
//           ),
//           horizontalSpace(20),
//           // Product List
//           Expanded(flex: 2, child: _buildProductList()),
//         ],
//       ),
//     );
//   }

//   Widget _buildProductList() {
//     final topProducts = TopProductsTable.getTopProducts(selectedProductCount);
//     final totalSales = TopProductsTable.getTotalSalesValue(
//       selectedProductCount,
//     );

//     return Container(
//       height: 300.h,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Product Details',
//             style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//           ),
//           verticalSpace(12),
//           Expanded(
//             child: ListView.builder(
//               itemCount: topProducts.length,
//               itemBuilder: (context, index) {
//                 final product = topProducts[index];
//                 final percentage = (product.salesValue / totalSales) * 100;
//                 final categoryColors = {
//                   'Dairy': const Color(0xFF4CAF50),
//                   'Drinks': const Color(0xFF2196F3),
//                   'Snacks': const Color(0xFFFF9800),
//                   'Frozen': const Color(0xFF9C27B0),
//                 };
//                 final color = categoryColors[product.category] ?? Colors.grey;

//                 return Container(
//                   margin: EdgeInsets.only(bottom: 8.h),
//                   padding: EdgeInsets.all(8.w),
//                   decoration: BoxDecoration(
//                     color: index == touchedIndex
//                         ? color.withOpacity(0.1)
//                         : Colors.transparent,
//                     borderRadius: BorderRadius.circular(6.r),
//                     border: Border.all(
//                       color: index == touchedIndex ? color : Colors.transparent,
//                       width: 1,
//                     ),
//                   ),
//                   child: Row(
//                     children: [
//                       Container(
//                         width: 12.w,
//                         height: 12.h,
//                         decoration: BoxDecoration(
//                           color: color,
//                           shape: BoxShape.circle,
//                         ),
//                       ),
//                       horizontalSpace(8),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               product.productName,
//                               style: TextStyle(
//                                 fontSize: 11.sp,
//                                 fontWeight: FontWeight.w600,
//                               ),
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             Text(
//                               '${product.unitsSold} units • \$${product.salesValue.toStringAsFixed(0)}',
//                               style: TextStyle(
//                                 fontSize: 9.sp,
//                                 color: Colors.grey.shade600,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                       Text(
//                         '${percentage.toStringAsFixed(1)}%',
//                         style: TextStyle(
//                           fontSize: 10.sp,
//                           fontWeight: FontWeight.bold,
//                           color: color,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLegend() {
//     final categories = <String>{'Dairy', 'Drinks', 'Snacks', 'Frozen'};
//     final categoryColors = {
//       'Dairy': const Color(0xFF4CAF50),
//       'Drinks': const Color(0xFF2196F3),
//       'Snacks': const Color(0xFFFF9800),
//       'Frozen': const Color(0xFF9C27B0),
//     };

//     return Container(
//       padding: EdgeInsets.all(12.w),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(8.r),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             'Categories',
//             style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
//           ),
//           verticalSpace(8),
//           Wrap(
//             spacing: 16.w,
//             runSpacing: 8.h,
//             children: categories.map((category) {
//               final color = categoryColors[category] ?? Colors.grey;
//               final topProducts = TopProductsTable.getTopProducts(
//                 selectedProductCount,
//               );
//               final categoryProducts = topProducts.where(
//                 (p) => p.category == category,
//               );
//               final categoryTotal = categoryProducts.fold(
//                 0.0,
//                 (sum, p) => sum + p.salesValue,
//               );
//               final totalSales = TopProductsTable.getTotalSalesValue(
//                 selectedProductCount,
//               );
//               final percentage = totalSales > 0
//                   ? (categoryTotal / totalSales) * 100
//                   : 0.0;

//               if (categoryProducts.isEmpty) return const SizedBox.shrink();

//               return Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     width: 12.w,
//                     height: 12.h,
//                     decoration: BoxDecoration(
//                       color: color,
//                       shape: BoxShape.circle,
//                     ),
//                   ),
//                   horizontalSpace(6),
//                   Text(
//                     '$category (${percentage.toStringAsFixed(1)}%)',
//                     style: TextStyle(
//                       fontSize: 12.sp,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               );
//             }).toList(),
//           ),
//         ],
//       ),
//     );
//   }
// }
