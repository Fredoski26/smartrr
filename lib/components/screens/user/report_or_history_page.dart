import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/ask_action.dart';
import 'consent_form_page.dart';

class ReportOrHistoryPage extends StatefulWidget {
  @override
  _ReportOrHistoryPageState createState() => _ReportOrHistoryPageState();
}

class _ReportOrHistoryPageState extends State<ReportOrHistoryPage> {
  final mScaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage('assets/background.png'), fit: BoxFit.cover),
      ),
      child: Scaffold(
        key: mScaffoldState,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('SmartRR'),
          actions: <Widget>[
            PopupMenuButton<More>(
              onSelected: (More result) => _more(result),
              tooltip: 'More',
              itemBuilder: (BuildContext context) => [
                PopupMenuItem<More>(
                  value: More.logout,
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(Icons.exit_to_app, color: Colors.purple,),
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Stack(
          children: <Widget>[
            Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                      child: new Material(
                        //True Button
                        color: Colors.transparent,
                        child: new InkWell(
                          onTap: () => _bottomSheet(context: context),
                          child: new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                  border: new Border.all(
                                      color: Colors.white, width: 5.0)),
                              padding: new EdgeInsets.all(20.0),
                              child: new Text(
                                "Report".toUpperCase(),
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
                          onTap: () =>
                              Navigator.pushNamed(context, '/casesHistory'),
                          child: new Center(
                            child: new Container(
                              decoration: new BoxDecoration(
                                  border: new Border.all(
                                      color: Colors.white, width: 5.0)),
                              padding: new EdgeInsets.all(20.0),
                              child: new Text(
                                "History".toUpperCase(),
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
          ],
        ),
      ),
    );
  }

  _bottomSheet({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Report for',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 2,
                  shadowColor: Colors.purple,
                  child: ListTile(
                    title: Text('Yourself'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _onReportTap(userType: true),
                  ),
                ),
                Card(
                  elevation: 2,
                  shadowColor: Colors.purple,
                  child: ListTile(
                    title: Text('Someone else'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () => _onReportTap(userType: false),
                  ),
                ),
              ],
            ),
          );
        }
    );
  }

  _onReportTap({bool userType}) async {
    Navigator.pop(context);
    await setUserTypePref(userType: userType).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) =>
              ConsentFormPage(),
        ),
      );
    });
  }

  _more(More result) {
    debugPrint(result.toString());
    switch (result) {
      case More.logout:
        debugPrint('Logout tapped!');
        askAction(
            actionText: 'Yes',
            cancelText: 'No',
            text: 'Do you want to logout?',
            context: context,
            func: _logout,
            cancelFunc: _stayHere);
        break;
    }
  }

  _logout() async {
    debugPrint('Logged Out!');
    await FirebaseAuth.instance.signOut().then((_) {
      clearPrefs().then((_) =>
          Navigator.pushNamedAndRemoveUntil(
              context, '/login', ModalRoute.withName('Login')));
    });
  }

  _stayHere() {
    Navigator.pop(context);
  }
}
