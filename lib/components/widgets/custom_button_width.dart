import 'package:flutter/material.dart';

class CustomButtonWidth extends StatelessWidget {
  final String title;
  final Function func;
  final Color color;
  final double borderRadius;
  final double width;
  final Color textColor;

  CustomButtonWidth(
      {this.textColor = Colors.black,
      this.title,
      this.func,
      this.color = Colors.white,
      this.borderRadius = 5,
      this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      child: TextButton(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            foregroundColor: MaterialStateProperty.all(color),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius)),
            )),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            this.title,
            style: TextStyle(
                color: this.textColor,
                fontSize: 18,
                fontWeight: FontWeight.w600),
          ),
        ),
        onPressed: func,
      ),
    );
  }
}
