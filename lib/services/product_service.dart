import 'package:smartrr/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ProdutService {
  static String _videoAPiBaseUrl =
      "https://mini-dashboard-api.onrender.com/products";

  static Future<List<Product>> getAllProducts() async {
    final res = await http.get(Uri.parse(_videoAPiBaseUrl));
    final List jsonData = jsonDecode(res.body)["products"];

    return jsonData
        .map(
          (video) => Product(
            name: video["name"],
            description: video["description"],
            price: video["price"],
            type: video["productType"],
            images: video["imgUrl"],
            items: video["items"],
            rating: video["rating"],
          ),
        )
        .toList();
  }
}
