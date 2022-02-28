import 'package:flutter/material.dart';
import 'package:smartrr/utils/colors.dart';

class CircularProgress extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(smartYellow),
      ),
    );
  }
}
