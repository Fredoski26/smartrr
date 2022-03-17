import 'package:flutter/material.dart';

class TextHeading extends StatelessWidget {
  TextHeading({Key key, @required this.text}) : super(key: key);
  final String text;

  final TextStyle _headingStyle = TextStyle().copyWith(
    fontWeight: FontWeight.bold,
    fontSize: 18,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(text, style: _headingStyle),
    );
  }
}
