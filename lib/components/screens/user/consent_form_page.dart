import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/report_case.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/text_to_speech.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'select_service_page.dart';
import 'package:smartrr/generated/l10n.dart';

class ConsentFormPage extends StatefulWidget {
  @override
  _ConsentFormPageState createState() => _ConsentFormPageState();
}

class _ConsentFormPageState extends State<ConsentFormPage> {
  bool acceptedValue = false;

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(_language.consentForm),
              actions: [
                LanguagePicker(),
                MyTts(
                  text: _language.consentFormData,
                  language: langNotifier.locale,
                )
              ],
            ),
            body: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: kToolbarHeight,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          _language.consentFormData,
                          style: TextStyle().copyWith(color: materialWhite),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: acceptedValue,
                            onChanged: (bool? newVal) {
                              setState(() {
                                acceptedValue = newVal!;
                              });
                            },
                          ),
                          Text(
                            _language.acceptTerms,
                            style: TextStyle().copyWith(color: materialWhite),
                          ),
                        ],
                      ),
                      TextButton(
                          onPressed: () {
                            if (acceptedValue)
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        Consumer<ThemeNotifier>(
                                          builder:
                                              (context, themeNotifier, child) =>
                                                  ReportCase(
                                            lang: langNotifier.locale,
                                          ),
                                        )),
                              );
                            else {
                              Fluttertoast.showToast(
                                msg: _language.pleaseAcceptTerms,
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor:
                                    Colors.black54.withOpacity(0.3),
                                textColor: Colors.white,
                                fontSize: 16.0,
                              );
                            }
                          },
                          child: Text(_language.accept)),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
