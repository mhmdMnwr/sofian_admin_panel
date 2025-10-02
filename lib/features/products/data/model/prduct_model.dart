import 'package:flutter/material.dart';
import 'package:sofian_admin_panel/core/theming/app_colors.dart';

class ProductModel {
  final String? id;
  final String? imageUrl;
  final String? name;
  final String? category;
  final double? price;
  final String? brand;
  final ProductState? productState;

  ProductModel({
    this.id,
    this.name,
    this.imageUrl,
    this.price,
    this.category,
    this.brand,
    this.productState,
  });

  String getProductState(BuildContext context) {
    bool isAvailable = productState == ProductState.available;
    return isAvailable ? 'Available' : 'Unavailable';
    // Text(
    //   isAvailable ? 'Available' : 'Unavailable',
    //   style: Theme.of(context).textTheme.bodySmall?.copyWith(
    //     color: isAvailable
    //         ? ColorsManager.delivered.withValues(alpha: 0.1)
    //         : ColorsManager.lossRed.withValues(alpha: 0.1),
    //     fontWeight: FontWeight.w500,
    //     fontSize: 12,
    //   ),
    // );
  }
}

enum ProductState { available, unavailable }

List<ProductModel> testProducts = [
  ProductModel(
    id: '1',
    imageUrl: "image number",
    name: 'Coca Cola',
    price: 80.0,
    category: 'Drinks',
    brand: 'Coca Cola',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '2',
    imageUrl: "image number",
    name: 'Pepsi',
    price: 75.0,
    category: 'Drinks',
    brand: 'Pepsi',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '3',
    imageUrl: "image number",
    name: 'Lay\'s Chips',
    price: 120.0,
    category: 'Chips',
    brand: 'Lay\'s',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '4',
    imageUrl: "image number",
    name: 'Pringles',
    price: 250.0,
    category: 'Chips',
    brand: 'Pringles',
    productState: ProductState.unavailable,
  ),
  ProductModel(
    id: '5',
    imageUrl: "image number",
    name: 'Danone Yogurt',
    price: 45.0,
    category: 'Yogurts',
    brand: 'Danone',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '6',
    imageUrl: "image number",
    name: 'Activia Yogurt',
    price: 50.0,
    category: 'Yogurts',
    brand: 'Activia',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '7',
    imageUrl: "image number",
    name: 'Oreo Cookies',
    price: 180.0,
    category: 'Snacks',
    brand: 'Oreo',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '8',
    imageUrl: "image number",
    name: 'KitKat',
    price: 95.0,
    category: 'Snacks',
    brand: 'Nestlé',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '9',
    imageUrl: "image number",
    name: 'Sprite',
    price: 78.0,
    category: 'Drinks',
    brand: 'Coca Cola',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '10',
    imageUrl: "image number",
    name: 'Fanta',
    price: 78.0,
    category: 'Drinks',
    brand: 'Coca Cola',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '11',
    imageUrl: "image number",
    name: 'Mountain Dew',
    price: 85.0,
    category: 'Drinks',
    brand: 'PepsiCo',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '12',
    imageUrl: "image number",
    name: 'Red Bull',
    price: 180.0,
    category: 'Energy Drinks',
    brand: 'Red Bull',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '13',
    imageUrl: "image number",
    name: 'Monster Energy',
    price: 220.0,
    category: 'Energy Drinks',
    brand: 'Monster',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '14',
    imageUrl: "image number",
    name: 'Doritos',
    price: 150.0,
    category: 'Chips',
    brand: 'Frito-Lay',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '15',
    imageUrl: "image number",
    name: 'Cheetos',
    price: 140.0,
    category: 'Chips',
    brand: 'Frito-Lay',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '16',
    imageUrl: "image number",
    name: 'Snickers',
    price: 110.0,
    category: 'Chocolate',
    brand: 'Mars',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '17',
    imageUrl: "image number",
    name: 'Twix',
    price: 105.0,
    category: 'Chocolate',
    brand: 'Mars',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '18',
    imageUrl: "image number",
    name: 'Mars Bar',
    price: 100.0,
    category: 'Chocolate',
    brand: 'Mars',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '19',
    imageUrl: "image number",
    name: 'Bounty',
    price: 95.0,
    category: 'Chocolate',
    brand: 'Mars',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '20',
    imageUrl: "image number",
    name: 'Milky Way',
    price: 90.0,
    category: 'Chocolate',
    brand: 'Mars',
    productState: ProductState.unavailable,
  ),
  ProductModel(
    id: '21',
    imageUrl: "image number",
    name: 'Nesquik',
    price: 65.0,
    category: 'Drinks',
    brand: 'Nestlé',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '22',
    imageUrl: "image number",
    name: 'Nescafe',
    price: 180.0,
    category: 'Coffee',
    brand: 'Nestlé',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '23',
    imageUrl: "image number",
    name: 'Lipton Tea',
    price: 45.0,
    category: 'Tea',
    brand: 'Lipton',
    productState: ProductState.available,
  ),
  ProductModel(
    id: '24',
    imageUrl: "image number",
    name: 'Aquafina Water',
    price: 25.0,
    category: 'Water',
    brand: 'PepsiCo',
    productState: ProductState.unavailable,
  ),
];

List<List<dynamic>> getProductsData(context) {
  return testProducts
      .map(
        (product) => [
          product.name,
          product.imageUrl,
          product.price?.toStringAsFixed(2),
          product.id,
          product.category,
          product.brand,
          product.getProductState(context),
        ],
      )
      .toList();
}
