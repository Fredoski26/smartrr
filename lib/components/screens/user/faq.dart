import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:accordion/accordion.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class FrequentlyAskedQuestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) => Scaffold(
            appBar: AppBar(title: Text("FAQ")),
            body: StreamBuilder(
              stream: DatabaseService().getFaqs().asStream(),
              builder: (context,
                  AsyncSnapshot<List<QueryDocumentSnapshot<Object>>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text("Something went wrong"),
                  );
                } else {
                  return Accordion(
                      maxOpenSections: 1,
                      headerPadding: const EdgeInsets.symmetric(
                          vertical: 14, horizontal: 22),
                      headerBackgroundColor: lightGrey,
                      headerBackgroundColorOpened: primaryColor,
                      contentBackgroundColor:
                          notifier.darkTheme ? lightGrey : Colors.white,
                      children: snapshot.data
                          .map((faq) => AccordionSection(
                                isOpen: false,
                                header: Text(
                                  faq["question"],
                                ),
                                content: Text(
                                  faq["answer"],
                                ),
                                contentHorizontalPadding: 22,
                                contentBorderWidth: 1,
                              ))
                          .toList());
                }
              },
            )));
  }
}
