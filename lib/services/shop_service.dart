import 'package:smartrr/env/env.dart';
import 'package:smartrr/models/order.dart';
import 'package:smartrr/models/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class ShopService {
  static String apiBaseUrl = Env.apiBaseUrl;

  static Future<List<Product>> getAllProducts() async {
    final res = await http.get(Uri.parse("$apiBaseUrl/products"));
    final List jsonData = jsonDecode(res.body)["products"];
    // print(jsonData);

    print("Decoded data");

    List<Product> products = [];

    jsonData.forEach((product) {
      products.add(
        Product(
          id: "1",
          name: "Birth Control Shot",
          description:
              "Birth Control Shot Birth Control Shot Birth Control Shot Birth Control Shot Birth Control Shot Birth Control Shot Birth Control Shot",
          price: 2000,
          type: ProductType.single,
          images: [
            ProductImage(
              url: "assets/images/image2.jpg",
            ),
            ProductImage(
              url: "assets/images/image2.jpg",
            )
          ],
          items: [],
        ),
      );
      print("Added");
    });
    //  = jsonData
    //     .map(
    //       (product) => Product(
    //         id: product["_id"],
    //         name: product["name"],
    //         description: product["description"],
    //         price: product["price"],
    //         type: product["productType"] == ProductType.multiple
    //             ? ProductType.multiple
    //             : ProductType.single,
    //         images: (product["imgUrl"] as List)
    //             .map((img) => ProductImage(url: img["url"]))
    //             .toList(),
    //         items: (product["items"] as List)
    //             .map((item) => ProductItem(
    //                 item: item["item"],
    //                 price: item["price"],
    //                 quantity: item["quantity"]))
    //             .toList(),
    //         rating: product["rating"],
    //       ),
    //     )
    //     .toList();

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

    print(response);
  }

  static Future<List<Order>> getAllOrders() async {
    final res = await http.get(Uri.parse("$apiBaseUrl/orders"));
    final List jsonData = jsonDecode(res.body)["orders"];

    return jsonData
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
          ),
        )
        .toList();
  }
}
