import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/shop/product_details.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/shop_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class LandscapeProductCard extends StatelessWidget {
  final Product product;
  LandscapeProductCard({super.key, required this.product});

  final _cartBox = Hive.box<Product>("cart");

  ButtonStyle textButtonStyle = ButtonStyle().copyWith(
    textStyle: MaterialStatePropertyAll(TextStyle().copyWith(fontSize: 12)),
    iconSize: MaterialStatePropertyAll(12),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => GestureDetector(
        onTap: () => Navigator.push(
          context,
          PageTransition(
            child: ProductDetails(
              product: product,
            ),
            type: PageTransitionType.rightToLeft,
          ),
        ),
        child: Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: theme.darkTheme ? darkGrey : Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          product.images![0].url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.name,
                          style: TextStyle().copyWith(
                            color: Color(0xFF222227),
                            height: 1.2,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "N${product.price}",
                          style: TextStyle().copyWith(
                            color: Color(0xFF595959),
                            fontSize: 16,
                            height: 2,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ValueListenableBuilder(
                                  valueListenable: _cartBox.listenable(),
                                  builder: (context, cart, __) {
                                    if (!ShopService.isInCart(product.id)) {
                                      return TextButton.icon(
                                        onPressed: () => ShopService.addtoCart(
                                            {product.id: product}),
                                        icon: Icon(Icons.add),
                                        label: Text("Add"),
                                        style: textButtonStyle,
                                      );
                                    } else {
                                      return TextButton.icon(
                                        onPressed: () =>
                                            ShopService.removeFromCart(
                                                product.id),
                                        icon: Icon(Icons.remove),
                                        label: Text("Remove"),
                                        style: textButtonStyle,
                                      );
                                    }
                                  }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
      ),
    );
  }
}
