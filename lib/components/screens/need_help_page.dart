import 'package:flutter/material.dart';
import 'user/consent_form_page.dart';
import 'user/select_service_page.dart';

class NeedHelpPage extends StatefulWidget {
  @override
  _NeedHelpPageState createState() => _NeedHelpPageState();
}

class _NeedHelpPageState extends State<NeedHelpPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Expanded(
                child: new Material(
              //True Button
              color: Colors.transparent,
              child: new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ConsentFormPage()));
                },
                child: new Center(
                  child: new Container(
                    decoration: new BoxDecoration(
                        border:
                            new Border.all(color: Colors.white, width: 5.0)),
                    padding: new EdgeInsets.all(20.0),
                    child: new Text(
                      "I NEED HELP",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
            Container(
              color: Colors.white,
              height: 0.5,
            ),
            Expanded(
                child: new Material(
              //True Button
              color: Colors.transparent,
              child: new InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              SelectServicePage()));
                },
                child: new Center(
                  child: new Container(
                    decoration: new BoxDecoration(
                        border:
                            new Border.all(color: Colors.white, width: 5.0)),
                    padding: new EdgeInsets.all(20.0),
                    child: new Text(
                      "EMERGENCY",
                      style: new TextStyle(
                        color: Colors.white,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
