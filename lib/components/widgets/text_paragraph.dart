import 'package:flutter/material.dart';

class TextParagraph extends StatelessWidget {
  const TextParagraph({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Text(text),
    );
  }
}
