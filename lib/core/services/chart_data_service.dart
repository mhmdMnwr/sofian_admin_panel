// import 'package:fl_chart/fl_chart.dart';
// import 'package:sofian_admin_panel/core/data/chart_data_table.dart';

// /// Service class for fetching chart data from database
// /// This simulates how you would structure your database calls
// class ChartDataService {
//   /// Fetch revenue data from database
//   /// In real implementation, this would make HTTP requests or database queries
//   static Future<List<FlSpot>> fetchRevenueData({
//     required String timePeriod,
//     String? startDate,
//     String? endDate,
//   }) async {
//     // Simulate network delay
//     await Future.delayed(const Duration(milliseconds: 500));

//     // For now, return data from table - replace with actual DB call
//     return ChartDataTable.getData(ChartType.revenue, timePeriod);
//   }

//   /// Fetch orders data from database
//   static Future<List<FlSpot>> fetchOrdersData({
//     required String timePeriod,
//     String? startDate,
//     String? endDate,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return ChartDataTable.getData(ChartType.orders, timePeriod);
//   }

//   /// Fetch clients data from database
//   static Future<List<FlSpot>> fetchClientsData({
//     required String timePeriod,
//     String? startDate,
//     String? endDate,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 500));
//     return ChartDataTable.getData(ChartType.clients, timePeriod);
//   }

//   /// Generic method to fetch any chart data
//   static Future<List<FlSpot>> fetchChartData({
//     required ChartType chartType,
//     required String timePeriod,
//     String? startDate,
//     String? endDate,
//   }) async {
//     switch (chartType) {
//       case ChartType.revenue:
//         return fetchRevenueData(
//           timePeriod: timePeriod,
//           startDate: startDate,
//           endDate: endDate,
//         );
//       case ChartType.orders:
//         return fetchOrdersData(
//           timePeriod: timePeriod,
//           startDate: startDate,
//           endDate: endDate,
//         );
//       case ChartType.clients:
//         return fetchClientsData(
//           timePeriod: timePeriod,
//           startDate: startDate,
//           endDate: endDate,
//         );
//     }
//   }
// }
