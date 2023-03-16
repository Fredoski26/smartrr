import 'package:smartrr/models/product.dart';

class Cart {
  List<Product> products;
  double total;

  Cart({required this.products, required this.total});
}
