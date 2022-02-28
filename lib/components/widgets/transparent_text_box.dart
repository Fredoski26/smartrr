import 'package:flutter/material.dart';

class TransparentTextBox extends StatelessWidget {
  final Function func;
  final Color color;
  final double borderRadius;
  final double width;
  final Color textColor;

  TransparentTextBox(
      {this.textColor = Colors.white,
      this.func,
      this.color = Colors.white,
      this.borderRadius = 5,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        func();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: TextField(
          style: TextStyle(color: textColor, fontSize: 18),
          maxLines: 5,
        ),
        decoration: BoxDecoration(
          color: Color(0x77000000),
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        width: this.width,
        height: 200,
      ),
    );
  }
}
