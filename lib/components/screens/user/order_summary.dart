import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/orders.dart';
import 'package:smartrr/env/env.dart';
import 'package:smartrr/models/product.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:uuid/uuid.dart';

class OrderSummary extends StatefulWidget {
  final Product product;
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
    required this.product,
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
    charge.putMetaData("product_name", widget.product.name);
    charge.putMetaData("product_id", widget.product.id);
    charge.putMetaData("user_id", widget.user);
    charge.putMetaData("lga", widget.lga);
    charge.putMetaData("delivery_fee", widget.deliveryFee);
    charge.putMetaData("total_amount", totalAmount);
    charge.putMetaData("address", widget.address);
    charge.putMetaData("landmark", widget.landMark);
    charge.putMetaData("state", widget.state);
    charge.putMetaData("purpose", "order");

    final items = widget.product.items!
        .map((item) =>
            {"item": item.item, "price": item.price, "quantity": item.quantity})
        .toList();

    charge.putMetaData("items", jsonEncode(items));

    charge.putCustomField("Name", widget.name);
    charge.putCustomField("Phone", widget.phone);
    charge.putCustomField("Product Name", widget.product.name);
    charge.putCustomField("Product ID", widget.product.id);
    charge.putCustomField("Product", widget.product.name);
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
        appBar: AppBar(title: Text("Order summary")),
        body: ListView(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            SizedBox(height: 20.0),
            Container(
              height: 150,
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: theme.darkTheme
                    ? Colors.grey.withOpacity(.2)
                    : Colors.white,
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Image.network(
                            widget.product.images![0].url,
                            fit: BoxFit.cover,
                            height: 140,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: TextStyle().copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              height: 1.2,
                            ),
                          ),
                          Text(
                            "N${widget.product.price}",
                            style: TextStyle().copyWith(
                              color: primaryColor,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 8.0),
                              child: Text(
                                content,
                                style: TextStyle().copyWith(
                                  fontSize: 13,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ]),
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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Delivery Details",
                    textAlign: TextAlign.center,
                    style: TextStyle().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: [
                      Text(
                        "Name: ${widget.name}",
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
                        "Phone: ${widget.phone}",
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
                        "Country: ${widget.country}",
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
                        "State: ${widget.state}",
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
                        "LGA: ${widget.lga}",
                        style: TextStyle().copyWith(
                          fontSize: 13,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Address: ${widget.address}",
                          style: TextStyle().copyWith(
                            fontSize: 13,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "Major Landmark: ${widget.landMark}",
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
                    "Payment Details",
                    textAlign: TextAlign.center,
                    style: TextStyle().copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${widget.product.name}"),
                      Text("------------"),
                      Text("N${widget.product.price}"),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Delivery Fee"),
                      Text("------------"),
                      Text("N${widget.deliveryFee}"),
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total"),
                      Text("------------"),
                      Text("N${widget.product.price + widget.deliveryFee}"),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 60),
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
    if (widget.product.type == ProductType.multiple) {
      content += widget.product.items!.map((item) => "${item.item}").join(", ");
    } else {
      content += widget.product.name;
    }
    plugin.initialize(publicKey: publicKey);
    totalAmount =
        (widget.product.price.toInt() + widget.deliveryFee.toInt()) * 100;
    super.initState();
  }
}
