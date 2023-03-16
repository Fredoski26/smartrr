import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/theme/svg_icons.dart';

class ShoppingCartWidget extends StatelessWidget {
  ShoppingCartWidget({super.key});

  final _cartBox = Hive.box<Product>("cart");

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _cartBox.listenable(),
        builder: (context, Box<dynamic> cart, __) {
          if (cart.length > 0) {
            return GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/cart"),
              child: Badge.count(
                count: cart.length!,
                child: SmartIcons.Cart,
              ),
            );
          }
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, "/cart"),
            child: SmartIcons.Cart,
          );
        });
  }
}
