import 'package:flutter/material.dart';
import 'package:smartrr/utils/colors.dart';

class LocationCell extends StatelessWidget {
  final String title;
  final Function func;
  final Color color;
  final double borderRadius;
  final double width;
  final Color textColor;
  final Color bgColor;

  LocationCell({
    this.textColor = darkGrey,
    required this.title,
    required this.func,
    this.color = darkGrey,
    this.borderRadius = 5,
    required this.width,
    this.bgColor = Colors.white,
  });

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
            fontSize: 22,
          ),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          border: Border.all(color: darkGrey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        width: this.width,
      ),
    );
  }
}
