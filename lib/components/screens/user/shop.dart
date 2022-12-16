import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartrr/components/screens/user/orders.dart';
import 'package:smartrr/components/screens/user/product_card.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/shop_service.dart';
import 'package:smartrr/utils/colors.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  late StreamController<List<Product>> _streamController;

  loadProducts() async {
    try {
      print("Fetching products");
      List<Product> products = await ShopService.getAllProducts();
      print("Done");
      _streamController.add(products);
      return products;
    } catch (e) {
      _streamController.addError(e);
    }
  }

  List<Product> _products = [
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
    Product(
        id: "2",
        name: "Sexual Health Kit",
        description:
            "Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit",
        price: 12000,
        type: ProductType.multiple,
        images: [
          ProductImage(
            url: "assets/images/image1.jpg",
          ),
          ProductImage(
            url: "assets/images/image1.jpg",
          )
        ],
        items: [
          ProductItem(item: "External condoms", price: 1000, quantity: 10),
          ProductItem(item: "Internal condoms", price: 1000, quantity: 3),
          ProductItem(item: "Gloves", price: 800, quantity: 3),
          ProductItem(item: "Lube", price: 500, quantity: 5),
        ])
  ];

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: primaryColor,
      ),
      child: Scaffold(
        body: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              expandedHeight: 100,
              floating: true,
              snap: true,
              centerTitle: false,
              flexibleSpace: FlexibleSpaceBar(
                title: Row(
                  children: [
                    Icon(Icons.store),
                    Text(
                      "SmartRR Store",
                      style: TextStyle().copyWith(
                        fontSize: 20.0,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                titlePadding: EdgeInsets.all(20.0),
              ),
              actions: [
                IconButton(
                  tooltip: "Orders",
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Orders()),
                  ),
                  icon: SvgPicture.asset(
                    "assets/icons/carbon_delivery.svg",
                    height: 30,
                    width: 30,
                    color: Colors.white,
                  ),
                )
              ],
            )
          ],
          body: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, Colors.white],
              ),
            ),
            child: StreamBuilder<List<Product>>(
                stream: _streamController.stream,
                builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isNotEmpty) {
                      return GridView.builder(
                        itemCount: snapshot.data!.length,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 9 / 12,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) => ProductCard(
                          product: snapshot.data![index],
                        ),
                      );
                    } else {
                      return Center(child: Text("No products to display"));
                    }
                  }

                  if (snapshot.hasError) {
                    return Center(
                      child: Text(snapshot.error.toString()),
                    );
                  } else
                    return SizedBox();
                }

                // GridView.count(
                //           childAspectRatio: 9 / 12,
                //           padding: EdgeInsets.all(20.0),
                //           crossAxisCount: 2,
                //           crossAxisSpacing: 10.0,
                //           mainAxisSpacing: 10.0,
                //           children: _products
                //               .map(
                //                 (product) => ProductCard(
                //                   product: product,
                //                 ),
                //               )
                //               .toList(),
                //         )
                ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _streamController = new StreamController();
    loadProducts();
    super.initState();
  }
}
