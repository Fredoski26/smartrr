import 'package:smartrr/env/env.dart';
import 'package:smartrr/models/order.dart';
import 'package:smartrr/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/utils/constants.dart';

abstract class ShopService {
  static String apiBaseUrl = Env.apiBaseUrl;
  static Box<Product> _cartBox = Hive.box<Product>(kcartBox);

  static Future<List<Product>> getAllProducts() async {
    final res = await http.get(Uri.parse("$apiBaseUrl/products"));
    final List jsonData = jsonDecode(res.body)["products"];

    List<Product> products = jsonData
        .map(
          (product) => Product(
            id: product["_id"],
            name: product["name"],
            description: product["description"],
            price: double.parse(product["price"]),
            type: product["productType"] == "multiple"
                ? ProductType.multiple
                : ProductType.single,
            images: (product["imgUrl"] as List)
                .map((img) => ProductImage(url: img["url"]))
                .toList(),
            items: (product["items"] as List)
                .map((item) => ProductItem(
                    item: item["item"],
                    price: double.parse(item["price"]),
                    quantity: int.parse(item["quantity"])))
                .toList(),
            rating: 5,
          ),
        )
        .toList();

    return products;
  }

  static Future<void> placeOrder(Order order) async {
    final apiAccessToken = Env.apiAccessToken;

    final data = {
      "name": order.name,
      "email": order.email,
      "phoneNumber": order.phoneNumber,
      "country": order.country,
      "state": order.state,
      "localGovernmentArea": order.localGovernmentArea,
      "address": order.address,
      "majorLandmark": order.majorLandmark,
      "paymentRef": order.paymentRef,
      "status": order.status,
      "userId": order.user,
    };
    final response = await http.post(
      Uri.parse("$apiBaseUrl/orders"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiAccessToken",
      },
      body: jsonEncode(data),
    );
  }

  static Future<List<Order>> getAllOrders({required String userId}) async {
    final res = await http.get(Uri.parse("$apiBaseUrl/orders?userId=$userId"));
    final List jsonData = jsonDecode(res.body)["orders"];

    jsonData.sort((a, b) => (DateTime.parse(b["createdAt"]))
        .compareTo(DateTime.parse(a["createdAt"])));

    final List<Order> orders = jsonData
        .map(
          (order) => Order(
            name: order["name"],
            email: order["email"],
            phoneNumber: order["phoneNumber"],
            country: "Nigeria",
            state: order["state"],
            localGovernmentArea: order["localGovernmentArea"],
            address: order["address"],
            majorLandmark: order["majorLandmark"],
            status: order["status"],
            paymentRef: order["paymentRef"],
            user: order["userId"],
            productName: order["productName"],
            productId: order["productId"],
            deliveryFee: 0,
            totalAmount: double.parse(order["totalAmount"].toString()),
          ),
        )
        .toList();

    return orders;
  }

  static addtoCart(Map<String, Product> products) async {
    await _cartBox.putAll(products);
  }

  static removeFromCart(String productId) async {
    await _cartBox.delete(productId);
  }

  static bool isInCart(String productId) {
    return _cartBox.containsKey(productId);
  }
}
