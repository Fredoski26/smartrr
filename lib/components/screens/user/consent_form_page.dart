import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/provider/language_provider.dart';
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
    final String consentFormData = _language.consentFormData;

    return Scaffold(
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
                  Text(
                    _language.consentForm,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    color: Color(0xFFF7EC03),
                    height: 0.5,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                      consentFormData,
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
                                  Consumer<LanguageNotifier>(
                                      builder: (context, langNotifier, child) =>
                                          SelectServicePage(
                                            lang: langNotifier.locale,
                                          )),
                            ),
                          );
                        else {
                          Fluttertoast.showToast(
                            msg: _language.pleaseAcceptTerms,
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54.withOpacity(0.3),
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
    ));
  }
}
