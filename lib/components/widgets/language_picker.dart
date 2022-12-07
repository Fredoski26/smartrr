import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/provider/language_provider.dart';

class LanguagePicker extends StatefulWidget {
  const LanguagePicker({super.key});

  @override
  State<LanguagePicker> createState() => _LanguagePickerState();
}

class _LanguagePickerState extends State<LanguagePicker> {
  final languages = S.delegate.supportedLocales;
  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => PopupMenuButton<String>(
            initialValue: langNotifier.locale,
            onSelected: (val) => langNotifier.changeLanguage(val),
            icon: Icon(Icons.translate_sharp),
            tooltip: S.of(context).language,
            itemBuilder: (context) {
              return languages.map((locale) {
                return PopupMenuItem<String>(
                    value: locale.languageCode,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          locale.languageCode == "en" ? "English" : "Hausa",
                          style: TextStyle(
                            fontSize: 16.0,
                          ),
                        )
                      ],
                    ));
              }).toList();
            }));
  }
}
