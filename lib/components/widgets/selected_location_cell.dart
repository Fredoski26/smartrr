import 'package:flutter/material.dart';
import 'package:smartrr/utils/colors.dart';

class BlackLocationCell extends StatelessWidget {
  final Widget child;
  final Function func;
  final Color color;
  final Color bgColor;
  final double borderRadius;
  final double verticalPadding;
  final double width;
  final Color textColor;

  BlackLocationCell(
      {this.textColor = null,
      this.child,
      this.func,
      this.color = null,
      this.borderRadius = 5,
      this.verticalPadding = 20,
      this.bgColor = primaryColor,
      this.width});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        func();
      },
      child: Container(
        padding:
            EdgeInsets.symmetric(horizontal: 16, vertical: verticalPadding),
        margin: EdgeInsets.symmetric(vertical: 6),
        child: child,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.all(Radius.circular(this.borderRadius)),
        ),
        width: this.width,
        // height: 100,
      ),
    );
  }
}
