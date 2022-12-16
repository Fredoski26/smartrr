enum ProductType { single, multiple }

class Product {
  String id;
  String name;
  String description;
  double price;
  ProductType type;
  double? rating;
  List<ProductItem>? items;
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
  });
}

class ProductItem {
  String item;
  double price;
  int quantity;

  ProductItem(
      {required this.item, required this.price, required this.quantity});
}

class ProductImage {
  String url;
  String? filename;

  ProductImage({required this.url, this.filename});
}

class ProductItemWithCheckbox extends ProductItem {
  bool isSelected;

  ProductItemWithCheckbox({
    this.isSelected = true,
    required super.item,
    required super.price,
    required super.quantity,
  });
}
