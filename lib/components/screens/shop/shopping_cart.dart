import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class ShoppingCart extends StatelessWidget {
  const ShoppingCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Badge.count(
      count: 1,
      child: Icon(FeatherIcons.shoppingCart),
    );
  }
}
