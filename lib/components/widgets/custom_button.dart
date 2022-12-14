import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final Function func;
  final Color color;
  final double borderRadius;
  final Color textColor;

  CustomButton(
      {this.textColor = Colors.black,
      required this.title,
      required this.func,
      this.color = Colors.white,
      this.borderRadius = 5});

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
              color: this.textColor, fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
      onPressed: () {
        func();
      },
    );
  }
}
