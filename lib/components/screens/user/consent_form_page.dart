import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/provider/language_provider.dart';
import '../../widgets/constants.dart';
import 'select_service_page.dart';

class ConsentFormPage extends StatefulWidget {
  @override
  _ConsentFormPageState createState() => _ConsentFormPageState();
}

class _ConsentFormPageState extends State<ConsentFormPage> {
  bool acceptedValue = false;

  @override
  Widget build(BuildContext context) {
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
                    'CONSENT FORM',
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
                      title: const Text(
                        'Accept Terms \& Conditions',
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
                            msg: "Please accept Terms \& Conditions",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black54.withOpacity(0.3),
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Text("Proceed")),
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
