import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ShoppingCartWidget extends StatelessWidget {
  ShoppingCartWidget({super.key});

  final _cartBox = Hive.box("cart");

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: _cartBox.listenable(),
        builder: (context, Box<dynamic> cart, __) {
          if (cart.length! > 0) {
            return Badge.count(
              count: cart.length!,
              child: Icon(FeatherIcons.shoppingCart),
            );
          }
          return Icon(FeatherIcons.shoppingCart);
        });
  }
}
