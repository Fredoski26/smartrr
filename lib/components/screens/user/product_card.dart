import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:smartrr/components/screens/user/multiple_product_details.dart';
import 'package:smartrr/models/product.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({Key key, @required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        PageTransition(
          child: MultipleProductDetails(
            product: product,
          ),
          type: PageTransitionType.rightToLeft,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Center(
              child: ClipRect(
                  child: Image.asset(
                product.images[0].url,
                height: 150,
                fit: BoxFit.cover,
              )),
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    product.name,
                    style: TextStyle().copyWith(
                      fontWeight: FontWeight.w500,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              "N${product.price}",
              style: TextStyle().copyWith(
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
