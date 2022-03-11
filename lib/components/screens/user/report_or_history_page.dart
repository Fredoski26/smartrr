import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/chatbot.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/ask_action.dart';
import 'consent_form_page.dart';
import '../../widgets/custom_drawer.dart';

class ReportOrHistoryPage extends StatefulWidget {
  @override
  _ReportOrHistoryPageState createState() => _ReportOrHistoryPageState();
}

class _ReportOrHistoryPageState extends State<ReportOrHistoryPage> {
  final mScaffoldState = GlobalKey<ScaffoldState>();

  void _openDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  BoxDecoration _actionButtonDecoration = BoxDecoration(boxShadow: [
    BoxShadow(
        color: Colors.black.withOpacity(0.25),
        blurRadius: 100,
        offset: Offset(0, 4))
  ]);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: mScaffoldState,
      drawer: CustomDrawer(),
      appBar: AppBar(
        title: Text("Smart RR"),
      ),
      body: Center(
        child: IntrinsicWidth(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: _actionButtonDecoration,
                child: ElevatedButton(
                  onPressed: () => _bottomSheet(context: context),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0, vertical: 20.0),
                    child: Text("Report a Case"),
                  ),
                ),
              ),
              Container(
                decoration: _actionButtonDecoration,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pushNamed("/about"),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0, vertical: 20.0),
                    child: Text("All About SMR"),
                  ),
                ),
              ),
              Container(
                decoration: _actionButtonDecoration,
                child: ElevatedButton(
                  onPressed: () {},
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 48.0, vertical: 20.0),
                    child: Text("Impact of Smart RR"),
                  ),
                ),
              ),
              // new Material(
              //   //True Button
              //   color: primaryColor,
              //   child: new InkWell(
              //     onTap: () => Navigator.pushNamed(context, '/casesHistory'),
              //     child: new Center(
              //       child: new Container(
              //         decoration: new BoxDecoration(
              //             border: new Border.all(
              //                 color: Colors.white, width: 5.0)),
              //         padding: new EdgeInsets.all(20.0),
              //         child: new Text(
              //           "History".toUpperCase(),
              //           style: new TextStyle(
              //             color: Colors.white,
              //             fontSize: 40.0,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          child: Icon(Icons.chat),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ChatBot()))),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Report for',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Yourself'),
                        onPressed: () => _onReportTap(userType: true),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Someone else'),
                        onPressed: () => _onReportTap(userType: false),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _onReportTap({bool userType}) async {
    Navigator.pop(context);
    await setUserTypePref(userType: userType).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ConsentFormPage(),
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
      clearPrefs().then((_) => Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('Login')));
    });
  }

  _stayHere() {
    Navigator.pop(context);
  }
}
