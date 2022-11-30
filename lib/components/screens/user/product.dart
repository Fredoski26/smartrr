import 'package:flutter/material.dart';

class Product extends StatelessWidget {
  const Product({Key key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ClipRect(
                child: Image.asset(
              "assets/images/image1.jpg",
              height: 150,
              fit: BoxFit.cover,
            )),
          ),
          Text(
            "Sexual Reproductive Kit",
            style: TextStyle().copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            "N12,000",
            style: TextStyle().copyWith(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
