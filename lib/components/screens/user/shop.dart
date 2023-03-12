import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smartrr/components/screens/user/orders.dart';
import 'package:smartrr/components/widgets/landscape_product_card.dart';
import 'package:smartrr/components/widgets/portrait_product_card.dart';
import 'package:smartrr/components/widgets/shopping_cart.dart';
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
  late TextEditingController _searchController;
  bool _isLoading = false;

  loadProducts() async {
    try {
      List<Product> products = await ShopService.getAllProducts();
      // cache first prduct image
      products.forEach((product) {
        precacheImage(NetworkImage(product.images![0].url), context);
      });

      _streamController.add(products);
      return products;
    } catch (e) {
      _streamController.addError(e);
    }
  }

  Future<Null> _handleRefresh() async {
    try {
      List<Product> products = await ShopService.getAllProducts();
      _streamController.add(products);
      return null;
    } catch (e) {
      _streamController.addError(e);
    }
  }

  Future<Null> _search(String search) async {
    try {
      setState(() => _isLoading = !_isLoading);
      List<Product> products = await ShopService.getAllProducts();
      _streamController.add(products
          .where((product) =>
              product.name.contains(RegExp(search, caseSensitive: false)))
          .toList());
      setState(() => _isLoading = !_isLoading);
      return null;
    } catch (e) {
      _streamController.addError(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarColor: materialWhite,
      ),
      child: Scaffold(
        backgroundColor: materialWhite,
        body: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: NestedScrollView(
            floatHeaderSlivers: true,
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              SliverAppBar(
                floating: true,
                snap: true,
                centerTitle: false,
                title: Text(
                  "Shop",
                  style: TextStyle().copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                automaticallyImplyLeading: false,
                leading: null,
                expandedHeight: 130,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.pin,
                  title: Form(
                      child: TextField(
                    onSubmitted: _search,
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search items...",
                      hintStyle: TextStyle().copyWith(fontSize: 14),
                      prefixIcon: Icon(FeatherIcons.search),
                      contentPadding: EdgeInsets.symmetric(vertical: 11.5),
                      isDense: true,
                      filled: true,
                      fillColor: Color(0xFFEBEBEB),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                    ),
                  )),
                  expandedTitleScale: 1,
                  titlePadding: EdgeInsets.all(20.0),
                ),
                actions: [
                  ShoppingCart()
                  // IconButton(
                  //   tooltip: "Orders",
                  //   onPressed: () => Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => Orders()),
                  //   ),
                  //   icon: SvgPicture.asset(
                  //     "assets/icons/carbon_delivery.svg",
                  //     height: 30,
                  //     width: 30,
                  //   ),
                  // )
                ],
              )
            ],
            body: RefreshIndicator(
              onRefresh: _handleRefresh,
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(),
                child: StreamBuilder<List<Product>>(
                    stream: _streamController.stream,
                    builder: (context, AsyncSnapshot<List<Product>> snapshot) {
                      if (_isLoading) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (!snapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasData) {
                        if (snapshot.data!.isNotEmpty) {
                          return GridView.builder(
                            itemCount: snapshot.data!.length,
                            gridDelegate:
                                SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent:
                                  screenWidth >= 400 ? 200 : screenWidth,
                              childAspectRatio:
                                  screenWidth >= 400 ? 9 / 13 : 16 / 9,
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
                          child: Text(
                            "${snapshot.error.toString()}\n Pull down to refresh",
                            textAlign: TextAlign.center,
                          ),
                        );
                      } else
                        return SizedBox();
                    }),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _streamController = new StreamController();
    _searchController = new TextEditingController();
    loadProducts();
    super.initState();
  }
}
