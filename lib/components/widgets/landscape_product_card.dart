import "package:flutter/material.dart";
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/delivery_details.dart';
import 'package:smartrr/components/screens/user/product_details.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class LandscapeProductCard extends StatelessWidget {
  final Product product;
  const LandscapeProductCard({super.key, required this.product});

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
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          "N${product.price}",
                          style: TextStyle().copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            height: 2,
                          ),
                        ),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: ElevatedButton.icon(
                                    icon: Icon(Icons.shopping_cart_outlined),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DeliveryDetails(
                                            product: Product(
                                          id: product.id,
                                          name: product.name,
                                          price: product.price,
                                          description: product.description,
                                          images: product.images,
                                          items: product.items,
                                          type: product.type,
                                        )),
                                      ),
                                    ),
                                    label: Text("Buy"),
                                  ),
                                ),
                              )
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
