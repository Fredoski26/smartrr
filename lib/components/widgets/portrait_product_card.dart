import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/product_details.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class PortraitProductCard extends StatelessWidget {
  final Product product;
  const PortraitProductCard({super.key, required this.product});

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    product.images![0].url,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      product.name,
                      style: TextStyle().copyWith(
                        fontWeight: FontWeight.w500,
                        height: 1.2,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
              Text(
                "N${product.price}",
                style: TextStyle().copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
