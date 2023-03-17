import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/shop/orders.dart';
import 'package:smartrr/env/env.dart';
import 'package:smartrr/models/cart.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:uuid/uuid.dart';

class OrderSummary extends StatefulWidget {
  final Cart cart;
  final String name;
  final String phone;
  final String email;
  final String country;
  final String state;
  final String lga;
  final String address;
  final String landMark;
  final double deliveryFee;
  final String user;
  const OrderSummary({
    super.key,
    required this.cart,
    required this.name,
    required this.phone,
    required this.email,
    required this.country,
    required this.state,
    required this.lga,
    required this.address,
    required this.landMark,
    this.deliveryFee = 2000,
    required this.user,
  });

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  String content = "Content: ";

  final publicKey = Env.paystackPublicKey;
  final plugin = PaystackPlugin();
  late double totalAmount;

  @override
  Widget build(BuildContext context) {
    Charge charge = Charge()
      ..amount = totalAmount.toInt()
      ..reference = _getReference()
      ..email = widget.email;

    charge.putMetaData("name", widget.name);
    charge.putMetaData("email", widget.email);
    charge.putMetaData("phone_number", widget.phone);
    charge.putMetaData("user_id", widget.user);
    charge.putMetaData("lga", widget.lga);
    charge.putMetaData("delivery_fee", widget.deliveryFee);
    charge.putMetaData("total_amount", totalAmount);
    charge.putMetaData("address", widget.address);
    charge.putMetaData("landmark", widget.landMark);
    charge.putMetaData("state", widget.state);
    charge.putMetaData("purpose", "order");

    final items = widget.cart.products
        .map((product) => {
              "productId": product.id,
              "productName": product.name,
              "price": product.price,
              "quantity": product.quantity,
            })
        .toList();
    charge.putMetaData("items", jsonEncode(items));

    // if (widget.product.type == ProductType.multiple) {
    //   final items = widget.product.items!
    //       .map((item) => {
    //             "item": item.item,
    //             "price": item.price,
    //             "quantity": item.quantity
    //           })
    //       .toList();

    //   charge.putMetaData("items", jsonEncode(items));
    // }

    charge.putCustomField("Name", widget.name);
    charge.putCustomField("Phone", widget.phone);
    charge.putCustomField("Purpose", "order");

    _pay() async {
      CheckoutResponse response = await plugin.checkout(
        context,
        charge: charge,
        method: CheckoutMethod.card,
        fullscreen: true,
        logo: Image.asset(
          "assets/logo.png",
          height: 50,
          width: 50,
        ),
      );

      if (response.status && response.verify) {
        showToast(msg: "Order successful", type: "success");
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Orders(),
          ),
          ModalRoute.withName("/shop"),
        );
      } else {
        showToast(msg: "Payment could not be processed", type: "error");
      }
    }

    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Scaffold(
        appBar: AppBar(
          title: Text("Order SUmmary"),
          backgroundColor: primaryColor,
          centerTitle: false,
          iconTheme: IconThemeData().copyWith(color: Colors.white),
        ),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.darkTheme
                    ? Colors.grey.withOpacity(.2)
                    : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Delivery Details",
                    style: TextStyle().copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(height: 52),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        "Name: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.name}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Phone: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.phone}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Country: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.country}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "State: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.state}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "LGA: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.lga}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Address: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.address}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Major Landmark: ",
                        style: TextStyle().copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "${widget.landMark}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0),
            Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.darkTheme
                    ? Colors.grey.withOpacity(.2)
                    : Colors.white,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    "Summary",
                    style: TextStyle().copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Divider(height: 52),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Subtotal"),
                      Text("N${widget.cart.total.toStringAsFixed(2)}")
                    ],
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery"),
                      Text("N${widget.deliveryFee.toStringAsFixed(2)}")
                    ],
                  ),
                  Divider(height: 52),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: TextStyle().copyWith(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        "N${(widget.deliveryFee + widget.cart.total).toStringAsFixed(2)}",
                        style: TextStyle().copyWith(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 55),
              child: TextButton(
                onPressed: _pay,
                child: Text("Place Order"),
              ),
            )
          ],
        ),
      ),
    );
  }

  String _getReference() {
    return Uuid().v4();
  }

  @override
  void initState() {
    // if (widget.product.type == ProductType.multiple) {
    //   content += widget.product.items!.map((item) => "${item.item}").join(", ");
    // } else {
    //   content += widget.product.name;
    // }
    plugin.initialize(publicKey: publicKey);
    totalAmount = (widget.cart.total + widget.deliveryFee.toInt()) * 100;
    super.initState();
  }
}
