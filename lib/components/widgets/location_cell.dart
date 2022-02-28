import 'package:flutter/material.dart';

class LocationCell extends StatelessWidget {
  final String title;
  final Function func;
  final Color color;
  final double borderRadius;
  final double width;
  final Color textColor;

  LocationCell(
      {this.textColor = Colors.white,
      this.title,
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
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              color: textColor, fontSize: 22, fontWeight: FontWeight.w600),
        ),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        width: this.width,
      ),
    );
  }
}
