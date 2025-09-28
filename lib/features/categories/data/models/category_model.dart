import 'package:flutter/material.dart';

class CategoryModel {
  late final String? id;
  late final String? name;
  late final String? imageUrl;

  CategoryModel({this.id, this.name, this.imageUrl});
}

List<List<dynamic>> getCategories() {
  return [
    ['Milk jjjjjjjjjjjj', Icons.local_drink],
    ['Cheese', Icons.cake],
    ['Bread', Icons.bakery_dining],
    ['Eggs', Icons.egg],
    ['Butter', Icons.egg_alt_rounded],
    ['Milk', Icons.local_drink],
    ['Cheese', Icons.cake],
    ['Bread', Icons.bakery_dining],
    ['Eggs', Icons.egg],
    ['Butter', Icons.egg_alt_rounded],
    ['Milk', Icons.local_drink],
    ['Cheese', Icons.cake],
    ['Bread', Icons.bakery_dining],
    ['Eggs', Icons.egg],
    ['Butter', Icons.egg_alt_rounded],
    ['Yogurt', Icons.icecream],
    ['Meat', Icons.restaurant],
    ['Fish', Icons.set_meal],
    ['Vegetables', Icons.eco],
    ['Cheese', Icons.cake],
    ['Bread', Icons.bakery_dining],
    ['Eggs', Icons.egg],
    ['Butter', Icons.egg_alt_rounded],
    ['Yogurt', Icons.icecream],
    ['Meat', Icons.restaurant],
    ['Fish', Icons.set_meal],
    ['Vegetables', Icons.eco],
    ['Cheese', Icons.cake],
    ['Bread', Icons.bakery_dining],
    ['Eggs', Icons.egg],
    ['Butter', Icons.egg_alt_rounded],
    ['Yogurt', Icons.icecream],
    ['Meat', Icons.restaurant],
    ['Fish', Icons.set_meal],
    ['Vegetables', Icons.eco],
    ['Fruits', Icons.apple],
  ];
}
