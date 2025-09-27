class ProductModel {
  late final String? id;
  late final String? name;
  late final double? price;
  late final String? category;
  late final String? brand;
  late final State? state;

  ProductModel({
    this.id,
    this.name,
    this.price,
    this.category,
    this.brand,
    this.state,
  });
}

enum State { available, unavailable }
