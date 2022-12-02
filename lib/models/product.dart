import 'package:flutter/foundation.dart';

enum ProductType { single, multiple }

class Product {
  String name;
  String description;
  double price;
  ProductType type;
  double rating;
  List<ProductItem> items;
  List<ProductImage> images;

  Product({
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.type,
    @required this.images,
    this.rating,
    this.items,
  });
}

class ProductItem {
  String item;
  double price;
  int quantity;

  ProductItem({this.item, this.price, this.quantity});
}

class ProductImage {
  String url;
  String filename;

  ProductImage({this.url, this.filename});
}
