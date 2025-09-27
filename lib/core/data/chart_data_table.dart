import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// Data model to simulate database structure for chart data
class ChartDataTable {
  // Revenue data tables
  static const List<FlSpot> revenueDaily = [
    FlSpot(0, 15000), // Sun
    FlSpot(1, 18000), // Mon
    FlSpot(2, 12000), // Tue
    FlSpot(3, 22000), // Wed
    FlSpot(4, 19000), // Thu
    FlSpot(5, 25000), // Fri
    FlSpot(6, 28000), // Sat
  ];

  static const List<FlSpot> revenueMonthly = [
    FlSpot(0, 20000), // Jan
    FlSpot(1, 35000), // Feb
    FlSpot(2, 25000), // Mar
    FlSpot(3, 45000), // Apr
    FlSpot(4, 30000), // May
    FlSpot(5, 55000), // Jun
    FlSpot(6, 65000), // Jul
    FlSpot(7, 75000), // Aug
    FlSpot(8, 85000), // Sep
    FlSpot(9, 95000), // Oct
    FlSpot(10, 110000), // Nov
    FlSpot(11, 130000), // Dec
  ];

  // Orders data tables
  static const List<FlSpot> ordersDaily = [
    FlSpot(0, 45), // Sun
    FlSpot(1, 52), // Mon
    FlSpot(2, 38), // Tue
    FlSpot(3, 67), // Wed
    FlSpot(4, 58), // Thu
    FlSpot(5, 75), // Fri
    FlSpot(6, 82), // Sat
  ];

  static const List<FlSpot> ordersMonthly = [
    FlSpot(0, 150), // Jan
    FlSpot(1, 280), // Feb
    FlSpot(2, 200), // Mar
    FlSpot(3, 350), // Apr
    FlSpot(4, 250), // May
    FlSpot(5, 420), // Jun
    FlSpot(6, 480), // Jul
    FlSpot(7, 550), // Aug
    FlSpot(8, 620), // Sep
    FlSpot(9, 680), // Oct
    FlSpot(10, 750), // Nov
    FlSpot(11, 850), // Dec
  ];

  // Clients data tables
  static const List<FlSpot> clientsDaily = [
    FlSpot(0, 25), // Sun
    FlSpot(1, 32), // Mon
    FlSpot(2, 18), // Tue
    FlSpot(3, 45), // Wed
    FlSpot(4, 38), // Thu
    FlSpot(5, 52), // Fri
    FlSpot(6, 61), // Sat
  ];

  static const List<FlSpot> clientsMonthly = [
    FlSpot(0, 50), // Jan
    FlSpot(1, 120), // Feb
    FlSpot(2, 80), // Mar
    FlSpot(3, 180), // Apr
    FlSpot(4, 140), // May
    FlSpot(5, 220), // Jun
    FlSpot(6, 260), // Jul
    FlSpot(7, 300), // Aug
    FlSpot(8, 350), // Sep
    FlSpot(9, 400), // Oct
    FlSpot(10, 450), // Nov
    FlSpot(11, 520), // Dec
  ];

  /// Get data for specific chart type and time period
  /// This method simulates fetching data from database
  static List<FlSpot> getData(ChartType chartType, String timePeriod) {
    switch (chartType) {
      case ChartType.revenue:
        return timePeriod == 'Last 7 days' ? revenueDaily : revenueMonthly;
      case ChartType.orders:
        return timePeriod == 'Last 7 days' ? ordersDaily : ordersMonthly;
      case ChartType.clients:
        return timePeriod == 'Last 7 days' ? clientsDaily : clientsMonthly;
    }
  }

  /// Get maximum Y value for proper chart scaling
  static double getMaxY(ChartType chartType, String timePeriod) {
    final data = getData(chartType, timePeriod);
    final maxValue = data.map((spot) => spot.y).reduce((a, b) => a > b ? a : b);

    // Add 10% padding to max value for better visualization
    return maxValue * 1.1;
  }

  /// Get appropriate grid interval based on data range
  static double getGridInterval(ChartType chartType, String timePeriod) {
    final maxY = getMaxY(chartType, timePeriod);

    if (maxY > 100000) return 20000;
    if (maxY > 10000) return 5000;
    if (maxY > 1000) return 200;
    if (maxY > 100) return 50;
    return 10;
  }
}

/// Product sales data model for pie chart
class ProductSalesData {
  final String productName;
  final double salesValue;
  final int unitsSold;
  final String category;

  const ProductSalesData({
    required this.productName,
    required this.salesValue,
    required this.unitsSold,
    required this.category,
  });
}

/// Top selling products data (sorted by sales value) - Grocery Shop
class TopProductsTable {
  static const List<ProductSalesData> topProducts = [
    ProductSalesData(
      productName: 'Greek Yogurt (Chobani)',
      salesValue: 8500,
      unitsSold: 1200,
      category: 'Dairy',
    ),
    ProductSalesData(
      productName: 'Coca-Cola (2L)',
      salesValue: 7800,
      unitsSold: 2600,
      category: 'chips',
    ),
    ProductSalesData(
      productName: 'Lay\'s Potato Chips',
      salesValue: 6900,
      unitsSold: 2300,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Organic Milk (1L)',
      salesValue: 6200,
      unitsSold: 1550,
      category: 'Frozen',
    ),
    ProductSalesData(
      productName: 'Energy Drink (Red Bull)',
      salesValue: 5800,
      unitsSold: 1160,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Oreo Cookies',
      salesValue: 5500,
      unitsSold: 1833,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Orange Juice (Fresh)',
      salesValue: 5200,
      unitsSold: 1040,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Yogurt Drink (Yakult)',
      salesValue: 4900,
      unitsSold: 1633,
      category: 'Dairy',
    ),
    ProductSalesData(
      productName: 'Chocolate Bar (Snickers)',
      salesValue: 4600,
      unitsSold: 2300,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Bottled Water (500ml)',
      salesValue: 4300,
      unitsSold: 4300,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Ice Cream (Ben & Jerry\'s)',
      salesValue: 4000,
      unitsSold: 500,
      category: 'Frozen',
    ),
    ProductSalesData(
      productName: 'Cheese (Cheddar)',
      salesValue: 3800,
      unitsSold: 633,
      category: 'Dairy',
    ),
    ProductSalesData(
      productName: 'Pringles (Original)',
      salesValue: 3600,
      unitsSold: 900,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Coffee (Instant)',
      salesValue: 3400,
      unitsSold: 567,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Frozen Pizza',
      salesValue: 3200,
      unitsSold: 400,
      category: 'Frozen',
    ),
    ProductSalesData(
      productName: 'Granola Bars',
      salesValue: 3000,
      unitsSold: 1000,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Sparkling Water',
      salesValue: 2800,
      unitsSold: 1400,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Butter (Salted)',
      salesValue: 2600,
      unitsSold: 520,
      category: 'Dairy',
    ),
    ProductSalesData(
      productName: 'Crackers (Ritz)',
      salesValue: 2400,
      unitsSold: 800,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Frozen Vegetables',
      salesValue: 2200,
      unitsSold: 440,
      category: 'Frozen',
    ),
    ProductSalesData(
      productName: 'Fruit Yogurt (Dannon)',
      salesValue: 2000,
      unitsSold: 500,
      category: 'Dairy',
    ),
    ProductSalesData(
      productName: 'Sports Drink (Gatorade)',
      salesValue: 1900,
      unitsSold: 633,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Nuts Mix (Trail Mix)',
      salesValue: 1800,
      unitsSold: 360,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Tea Bags (Lipton)',
      salesValue: 1700,
      unitsSold: 567,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Frozen Berries',
      salesValue: 1600,
      unitsSold: 320,
      category: 'Frozen',
    ),
    ProductSalesData(
      productName: 'Protein Yogurt',
      salesValue: 1500,
      unitsSold: 300,
      category: 'Dairy',
    ),
    ProductSalesData(
      productName: 'Popcorn (Microwave)',
      salesValue: 1400,
      unitsSold: 700,
      category: 'Snacks',
    ),
    ProductSalesData(
      productName: 'Smoothie (Bottled)',
      salesValue: 1300,
      unitsSold: 260,
      category: 'Drinks',
    ),
    ProductSalesData(
      productName: 'Frozen French Fries',
      salesValue: 1200,
      unitsSold: 300,
      category: 'Frozen',
    ),
    ProductSalesData(
      productName: 'Cream Cheese',
      salesValue: 1100,
      unitsSold: 275,
      category: 'Dairy',
    ),
  ];

  /// Get top N products by sales value
  static List<ProductSalesData> getTopProducts(int count) {
    if (count <= 0) return [];
    return topProducts.take(count).toList();
  }

  /// Get total sales value for top N products
  static double getTotalSalesValue(int count) {
    final products = getTopProducts(count);
    return products.fold(0.0, (sum, product) => sum + product.salesValue);
  }

  /// Convert product data to PieChartSectionData
  static List<PieChartSectionData> getPieChartSections(int count) {
    final products = getTopProducts(count);
    final totalValue = getTotalSalesValue(count);

    // Define colors for different grocery categories
    final categoryColors = {
      'Dairy': const Color(0xFF012350),
      'chips': const Color(0xFF00B4D8),
      'Drinks': const Color(0xFF024CAA),
      'Snacks': const Color(0xFF27548A),
      'Frozen': const Color(0xFF00809D), // Purple for frozen
    };

    return products.asMap().entries.map((entry) {
      final product = entry.value;
      final percentage = (product.salesValue / totalValue) * 100;
      final color = categoryColors[product.category] ?? Colors.grey;

      return PieChartSectionData(
        color: color,
        value: product.salesValue,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }
}

enum ChartType { revenue, orders, clients }
