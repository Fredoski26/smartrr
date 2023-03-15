import 'package:hive/hive.dart';

part 'product.g.dart';

@HiveType(typeId: 5)
enum ProductType {
  @HiveField(0)
  single,
  @HiveField(1)
  multiple
}

@HiveType(typeId: 1)
class Product {
  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  double price;
  @HiveField(4)
  ProductType type;
  @HiveField(5)
  double? rating;
  @HiveField(6)
  int quantity;
  @HiveField(7)
  List<ProductItem>? items;
  @HiveField(8)
  List<ProductImage>? images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.type,
    required this.images,
    this.rating,
    this.items,
    this.quantity = 1,
  });
}

@HiveType(typeId: 2)
class ProductItem {
  @HiveField(0)
  String item;
  @HiveField(1)
  double price;
  @HiveField(2)
  int quantity;

  ProductItem(
      {required this.item, required this.price, required this.quantity});
}

@HiveType(typeId: 3)
class ProductImage {
  @HiveField(0)
  String url;
  @HiveField(1)
  String? filename;

  ProductImage({required this.url, this.filename});
}

@HiveType(typeId: 4)
class ProductItemWithCheckbox extends ProductItem {
  @HiveField(3)
  bool isSelected;

  ProductItemWithCheckbox({
    this.isSelected = true,
    required super.item,
    required super.price,
    required super.quantity,
  });
}
