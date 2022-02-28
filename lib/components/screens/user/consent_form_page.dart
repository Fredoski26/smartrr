import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
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
                      color: Colors.white,
                      fontSize: 28,
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
                      style: TextStyle(color: Colors.white),
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
                          color: Color(0xFFF7EC03),
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
                  GestureDetector(
                    child: Card(
//                  color: Color(0xFFB6DCFE),
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 30, vertical: 12),
                          child: Text(
                            'PROCEED',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600),
                          ),
                        )),
                    onTap: () {
                      if (acceptedValue)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                SelectServicePage(),
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
                  ),
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
