import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartrr/components/screens/user/orders.dart';
import 'package:smartrr/components/widgets/landscape_product_card.dart';
import 'package:smartrr/components/widgets/portrait_product_card.dart';
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
      List<Product> products = await ShopService.getAllProducts();

      _streamController.add(products);
      return products;
    } catch (e) {
      _streamController.addError(e);
    }
  }

  List<Product> _products = [
    Product(
        id: "2",
        name: "Sexual Health Kit",
        description:
            "Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit Sexual Health Kit",
        price: 9300,
        type: ProductType.multiple,
        images: [
          ProductImage(
            url:
                "https://mini-test-dashboard.s3.us-west-1.amazonaws.com/images/1671217728483-image1.jpg",
          )
        ],
        items: [
          ProductItem(item: "External condoms", price: 300, quantity: 10),
          ProductItem(item: "Internal condoms", price: 1000, quantity: 3),
          ProductItem(item: "Gloves", price: 100, quantity: 3),
          ProductItem(item: "Lube", price: 1500, quantity: 2),
        ])
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    print(screenWidth);
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
            padding: EdgeInsets.all(10.0),
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
                          maxCrossAxisExtent:
                              screenWidth >= 400 ? 200 : screenWidth,
                          childAspectRatio:
                              screenWidth >= 400 ? 9 / 12 : 16 / 9,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0,
                        ),
                        itemBuilder: (context, index) {
                          if (screenWidth >= 400) {
                            return PortraitProductCard(
                                product: snapshot.data![index]);
                          } else
                            return LandscapeProductCard(
                                product: snapshot.data![index]);
                        },
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
                }),
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
