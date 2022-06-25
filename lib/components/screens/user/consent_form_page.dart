import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/text_to_speech.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/theme_provider.dart';
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
            body: Stack(
              children: <Widget>[
                Scrollbar(
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
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Center(
                            child: CheckboxListTile(
                              title: Text(
                                _language.acceptTerms,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                              onChanged: (bool newVal) {
                                setState(() {
                                  acceptedValue = newVal;
                                });
                              },
                              value: acceptedValue,
//              secondary: const Icon(Icons.hourglass_empty),
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (acceptedValue)
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Consumer<ThemeNotifier>(
                                              builder: (context, themeNotifier,
                                                      child) =>
                                                  SelectServicePage(
                                                lang: langNotifier.locale,
                                                isDarkTheme:
                                                    themeNotifier.darkTheme,
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
                              child: Text(_language.proceed)),
                          SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )));
  }
}
