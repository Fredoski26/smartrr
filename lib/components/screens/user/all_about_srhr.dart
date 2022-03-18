import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/list_item.dart';
import 'package:smartrr/components/widgets/text_heading.dart';
import 'package:smartrr/components/widgets/text_paragraph.dart';
import 'package:smartrr/components/widgets/text_to_speech.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AllAboutSRHR extends StatelessWidget {
  const AllAboutSRHR({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
              appBar: AppBar(
                title: Text(_language.allAboutSRHR),
                actions: [
                  LanguagePicker(),
                  MyTts(
                    text: [
                      _language.srhrHeading1,
                      _language.srhrParagraph1,
                      _language.srhrHeading2,
                      _language.srhrParagraph2,
                      _language.srhrParagraph3,
                      _language.srhrParagraph4,
                      _language.srhrParagraph5,
                      _language.srhrParagraph6,
                      _language.srhrHeading4,
                      _language.srhrDefinition1Title,
                      _language.srhrDefinition1Body,
                      _language.srhrDefinition1SubList1Title,
                      _language.srhrDefinition1SubList1Item1,
                      _language.srhrDefinition1SubList1Item2,
                      _language.srhrDefinition1SubList1Item3,
                      _language.srhrDefinition2Title,
                      _language.srhrDefinition2Body,
                      _language.srhrDefinition3Title,
                      _language.srhrDefinition3Body
                    ].join(""),
                    language: langNotifier.locale,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextHeading(text: _language.srhrHeading1),
                      TextParagraph(text: _language.srhrParagraph1),
                      TextHeading(text: _language.srhrHeading2),
                      TextParagraph(text: _language.srhrParagraph2),
                      TextParagraph(text: _language.srhrParagraph3),
                      TextParagraph(text: _language.srhrParagraph4),
                      TextParagraph(text: _language.srhrParagraph5),
                      TextParagraph(text: _language.srhrParagraph6),
                      TextHeading(text: _language.srhrHeading4),
                      ListItem(
                          title: _language.srhrDefinition1Title,
                          label: "A",
                          body: _language.srhrDefinition1Body),
                      Text(_language.srhrDefinition1SubList1Title),
                      ListItem(body: _language.srhrDefinition1SubList1Item1),
                      ListItem(body: _language.srhrDefinition1SubList1Item2),
                      ListItem(body: _language.srhrDefinition1SubList1Item3),
                      ListItem(
                          label: "B",
                          title: _language.srhrDefinition2Title,
                          body: _language.srhrDefinition2Body),
                      ListItem(
                          label: "C",
                          title: _language.srhrDefinition3Title,
                          body: _language.srhrDefinition3Body),
                      langNotifier.locale == "en"
                          ? TextButton(
                              onPressed: () async {
                                await launch(
                                  "https://docs.google.com/document/d/170XeWJLKtTo2GOufFgnhqqmZ1tFyfoAv/edit?usp=sharing&ouid=102250998567041919901&rtpof=true&sd=true",
                                );
                              },
                              child: Text("${_language.readMore}.."),
                            )
                          : TextButton(
                              onPressed: () async {
                                await launch(
                                  "https://docs.google.com/document/d/1gCIciVW4qZTHgGd8tNJDX-mtDKcIutAF/edit?usp=sharing&ouid=102250998567041919901&rtpof=true&sd=true",
                                );
                              },
                              child: Text("${_language.readMore}..."),
                            ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
