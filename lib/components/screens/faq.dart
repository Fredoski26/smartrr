import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';

class FrequentlyAskedQuestions extends StatelessWidget {
  final _headerStyle = TextStyle(color: Colors.white);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("FAQ")),
      body: Accordion(
          maxOpenSections: 1,
          headerPadding:
              const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
          headerBackgroundColor: Color(0xFFEFEFEF),
          headerBackgroundColorOpened: Color(0xFFEFEFEF),
          children: [
            AccordionSection(
              isOpen: false,
              leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
              header: Text(
                'What does FGM mean?',
              ),
              content: Text(
                "Female genital mutilation (FGM) involves the partial or total removal of external female genitalia or other injury to the female genital organs for non-medical reasons. The practice has no health benefits for girls and women",
              ),
              contentHorizontalPadding: 22,
              contentBorderWidth: 1,
            ),
          ]),
    );
  }
}
