import 'package:smartrr/models/product.dart';

class Cart {
  List<Product> products;
  int total;

  Cart({required this.products, required this.total});
}
