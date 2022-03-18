import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class FrequentlyAskedQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) => Scaffold(
              appBar: AppBar(title: Text("FAQ")),
              body: Accordion(
                  maxOpenSections: 1,
                  headerPadding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
                  headerBackgroundColor: lightGrey,
                  headerBackgroundColorOpened: primaryColor,
                  contentBackgroundColor:
                      notifier.darkTheme ? lightGrey : Colors.white,
                  children: [
                    AccordionSection(
                      isOpen: false,
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
            ));
  }
}
