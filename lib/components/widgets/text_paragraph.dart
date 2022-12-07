import 'package:flutter/material.dart';

class TextParagraph extends StatelessWidget {
  const TextParagraph({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: SelectableText(text),
    );
  }
}
