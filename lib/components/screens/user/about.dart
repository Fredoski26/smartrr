import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/components/widgets/text_to_speech.dart';

class About extends StatefulWidget {
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);
    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
              appBar: AppBar(
                title: Text(_language.aboutSmartRR),
                actions: [
                  LanguagePicker(),
                  MyTts(
                    text: _language.aboutSmartrrData,
                    language: langNotifier.locale,
                  )
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 150,
                          width: 150,
                          child: Image.asset("assets/logo.png"),
                        ),
                      ],
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      padding: EdgeInsets.symmetric(
                          vertical: 33.0, horizontal: 36.0),
                      child: Text(
                        _language.aboutSmartrrData,
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
