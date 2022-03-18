import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/org/org_cases_screen.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/ask_action.dart';

class ReferOrCasesPage extends StatefulWidget {
  @override
  _ReferOrCasesPageState createState() => _ReferOrCasesPageState();
}

class _ReferOrCasesPageState extends State<ReferOrCasesPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
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
                        child: Icon(
                          Icons.exit_to_app,
                          color: primaryColor,
                        ),
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
                    child: new InkWell(
                      onTap: () => Navigator.pushNamed(context, '/refer'),
                      child: new Center(
                        child: new Container(
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: primaryColor, width: 5.0)),
                          padding: new EdgeInsets.all(20.0),
                          child: new Text(
                            "Refer".toUpperCase(),
                            style: new TextStyle(
                              color: primaryColor,
                              fontSize: 40.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )),
                  Container(
                    color: primaryColor,
                    height: 0.5,
                  ),
                  Expanded(
                      child: new Material(
                    //True Button
                    child: new InkWell(
                      onTap: () async {
                        String orgId = await getOrgIdPref();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => OrgCasesScreen(
                              orgId: orgId,
                            ),
                          ),
                        );
                      },
                      child: new Center(
                        child: new Container(
                          decoration: new BoxDecoration(
                              border: new Border.all(
                                  color: primaryColor, width: 5.0)),
                          padding: new EdgeInsets.all(20.0),
                          child: new Text(
                            "Cases".toUpperCase(),
                            style: new TextStyle(
                              color: primaryColor,
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
      clearPrefs().then((_) => Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('Login')));
    });
  }

  _stayHere() {
    Navigator.pop(context);
  }
}
