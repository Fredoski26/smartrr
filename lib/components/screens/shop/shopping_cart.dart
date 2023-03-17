import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/components/widgets/cart_item.dart';

class ShoppingCart extends StatefulWidget {
  const ShoppingCart({super.key});

  @override
  State<ShoppingCart> createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  late Box<Product> _cartBox;

  double getTotalPrice() {
    double total = 0;
    _cartBox.values
        .forEach((product) => total += (product.price * product.quantity));
    return total;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cart"),
        backgroundColor: primaryColor,
      ),
      body: ValueListenableBuilder(
        valueListenable: _cartBox.listenable(),
        builder: (context, Box<Product> cart, __) => ListView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          children: [
            ListView.separated(
              itemCount: cart.length,
              separatorBuilder: (context, _) => Divider(),
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              itemBuilder: ((context, index) {
                if (cart.isNotEmpty) {
                  return CartItem(
                    product: cart.getAt(index)!,
                    productKey: index,
                  );
                }
                return Center(
                  child: Text("Your cart is empty"),
                );
              }),
            ),
            SizedBox(height: 54),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total",
                  style: TextStyle().copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222227),
                    fontSize: 20,
                  ),
                ),
                Text(
                  "N${getTotalPrice().toStringAsFixed(2)}",
                  style: TextStyle().copyWith(
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF222227),
                    fontSize: 20,
                  ),
                )
              ],
            ),
            SizedBox(height: 36),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () {},
                    child: Text("Continue to Checkout"),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    _cartBox = Hive.box<Product>("cart");

    super.initState();
  }
}
