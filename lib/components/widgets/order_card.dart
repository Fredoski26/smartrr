import 'package:flutter/material.dart';
import 'package:smartrr/models/order.dart';
import 'package:smartrr/utils/colors.dart';

class OrderCard extends StatelessWidget {
  final Order order;
  const OrderCard({super.key, required this.order});

  Widget orderStatus(String status) {
    switch (status) {
      case "delivered":
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.green.withOpacity(.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle().copyWith(color: Colors.green, fontSize: 12),
          ),
        );
      case "shipped":
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle().copyWith(color: Colors.blue, fontSize: 12),
          ),
        );
      default:
        return Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(.2),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            status,
            style: TextStyle().copyWith(color: primaryColor, fontSize: 12),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Product: ",
                  style: TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                Expanded(child: Text(order.productName))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Email: ",
                  style: TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                Expanded(child: Text(order.email))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Phone: ",
                  style: TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                Expanded(child: Text(order.phoneNumber))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment Reference: ",
                  style: TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                Expanded(child: Text(order.paymentRef))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Address: ",
                  style: TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                Expanded(child: Text(order.address))
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(bottom: 5),
            child: Row(
              children: [
                Text(
                  "Status: ",
                  style: TextStyle().copyWith(fontWeight: FontWeight.w600),
                ),
                orderStatus(order.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
