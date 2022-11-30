import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartrr/components/screens/user/product.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/utils/colors.dart';

class Shop extends StatefulWidget {
  const Shop({Key key});

  @override
  State<Shop> createState() => _ShopState();
}

class _ShopState extends State<Shop> {
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
                  children: [
                    Product(),
                    Product(),
                    Product(),
                    Product(),
                    Product(),
                    Product(),
                    Product(),
                    Product()
                  ],
                ))),
      ),
    );
  }
}
