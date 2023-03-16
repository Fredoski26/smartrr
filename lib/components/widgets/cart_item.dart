import "package:flutter/material.dart";
import 'package:hive_flutter/hive_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/shop/product_details.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/shop_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class CartItem extends StatefulWidget {
  final Product product;
  final int productKey;
  const CartItem({super.key, required this.product, required this.productKey});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  late Box<Product> _cartBox;
  late double productPrice;
  late final Product product;
  late final productKey;

  Widget ProductQuantitySelector() {
    updateCart() async {
      await _cartBox.putAt(
        productKey,
        Product(
          id: product.id,
          name: product.name,
          description: product.description,
          price: product.price,
          type: product.type,
          images: product.images,
          quantity: widget.product.quantity,
        ),
      );
    }

    incrementProductQuantity() {
      ++widget.product.quantity;
      productPrice += widget.product.price;
      updateCart();
      setState(() {});
    }

    decrementProductQuantity() {
      --widget.product.quantity;
      productPrice -= widget.product.price;
      updateCart();
      setState(() {});
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        IconButton(
          onPressed: widget.product.quantity > 1
              ? () => decrementProductQuantity()
              : null,
          color: primaryColor,
          icon: Icon(
            Icons.remove_circle_outline,
            size: 20,
          ),
        ),
        SizedBox(width: 5.0),
        Text(widget.product.quantity.toString()),
        SizedBox(width: 5.0),
        IconButton(
          onPressed: widget.product.quantity < 10
              ? () => incrementProductQuantity()
              : null,
          color: primaryColor,
          icon: Icon(
            Icons.add_circle_outline,
            size: 20,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: theme.darkTheme ? darkGrey : Colors.white,
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => Navigator.push(
                context,
                PageTransition(
                  child: ProductDetails(
                    product: widget.product,
                  ),
                  type: PageTransitionType.rightToLeft,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: Image.network(
                      widget.product.images![0].url,
                      fit: BoxFit.cover,
                      height: 94,
                      width: 112,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle().copyWith(
                              color: Color(0xFF222227),
                              height: 1.2,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            "N${productPrice.toStringAsFixed(2)}",
                            style: TextStyle().copyWith(
                              color: Color(0xFF595959),
                              fontSize: 16,
                              height: 2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () => ShopService.removeFromCart(widget.product.id),
                  child: Text(
                    "Remove",
                    style: TextStyle().copyWith(
                      fontSize: 14,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                ProductQuantitySelector()
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _cartBox = Hive.box<Product>("cart");
    product = widget.product;
    productKey = widget.productKey;
    productPrice = widget.product.price * widget.product.quantity;
    super.initState();
  }
}
