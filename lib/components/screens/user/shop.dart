import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrr/components/screens/user/product_card.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/utils/colors.dart';

class Shop extends StatefulWidget {
  const Shop({super.key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<Product> _products = [
    Product(
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
              leadingWidth: 0,
              leading: Container(),
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
            )
          ],
          body: Container(
            // padding: EdgeInsets.only(top: 50.0),
            decoration: BoxDecoration(
              color: primaryColor,
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [primaryColor, Colors.white],
              ),
            ),
            child: GridView.count(
              childAspectRatio: 9 / 12,
              padding: EdgeInsets.all(20.0),
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
              children: _products
                  .map(
                    (product) => ProductCard(
                      product: product,
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
