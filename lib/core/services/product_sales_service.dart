// import 'package:sofian_admin_panel/core/data/chart_data_table.dart';

// /// Service class for fetching product sales data from database
// /// This simulates how you would structure your database calls for product data
// class ProductSalesService {
//   /// Fetch top selling products from database
//   /// In real implementation, this would make HTTP requests or database queries
//   static Future<List<ProductSalesData>> fetchTopProducts({
//     required int limit,
//     String? category,
//     String? timePeriod,
//   }) async {
//     // Simulate network delay
//     await Future.delayed(const Duration(milliseconds: 600));

//     // In real app, this would be an API call like:
//     // final response = await http.get('/api/products/top-selling?limit=$limit&category=$category&period=$timePeriod');
//     // return parseProductData(response.data);

//     var products = TopProductsTable.getTopProducts(limit);

//     // Filter by category if specified
//     if (category != null && category.isNotEmpty) {
//       products = products
//           .where((product) => product.category == category)
//           .toList();
//     }

//     return products;
//   }

//   /// Fetch product sales by category
//   static Future<Map<String, double>> fetchSalesByCategory({
//     required int topProductsCount,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));

//     final topProducts = TopProductsTable.getTopProducts(topProductsCount);
//     final salesByCategory = <String, double>{};

//     for (final product in topProducts) {
//       salesByCategory[product.category] =
//           (salesByCategory[product.category] ?? 0) + product.salesValue;
//     }

//     return salesByCategory;
//   }

//   /// Fetch total sales statistics
//   static Future<Map<String, dynamic>> fetchSalesStats({
//     required int topProductsCount,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 300));

//     final topProducts = TopProductsTable.getTopProducts(topProductsCount);
//     final totalSales = topProducts.fold(
//       0.0,
//       (sum, product) => sum + product.salesValue,
//     );
//     final totalUnits = topProducts.fold(
//       0,
//       (sum, product) => sum + product.unitsSold,
//     );

//     // Group by category for stats
//     final categoriesCount = topProducts.map((p) => p.category).toSet().length;

//     return {
//       'totalSales': totalSales,
//       'totalUnits': totalUnits,
//       'averageSalesPerProduct': totalSales / topProducts.length,
//       'categoriesCount': categoriesCount,
//       'topProduct': topProducts.isNotEmpty ? topProducts.first.productName : '',
//       'topProductSales': topProducts.isNotEmpty
//           ? topProducts.first.salesValue
//           : 0.0,
//     };
//   }

//   /// Search products by name or category
//   static Future<List<ProductSalesData>> searchProducts({
//     required String query,
//     int limit = 20,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 400));

//     final allProducts = TopProductsTable.topProducts;
//     final filteredProducts = allProducts
//         .where((product) {
//           final searchQuery = query.toLowerCase();
//           return product.productName.toLowerCase().contains(searchQuery) ||
//               product.category.toLowerCase().contains(searchQuery);
//         })
//         .take(limit)
//         .toList();

//     return filteredProducts;
//   }

//   /// Get available categories
//   static Future<List<String>> fetchCategories() async {
//     await Future.delayed(const Duration(milliseconds: 200));

//     final categories = TopProductsTable.topProducts
//         .map((product) => product.category)
//         .toSet()
//         .toList();

//     categories.sort();
//     return categories;
//   }
// }
