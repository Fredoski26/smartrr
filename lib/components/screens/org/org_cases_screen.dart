import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/selected_location_cell.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/show_loading.dart';
import 'package:smartrr/utils/colors.dart';

class OrgCasesScreen extends StatefulWidget {
  final String orgId;

  const OrgCasesScreen({Key key, @required this.orgId}) : super(key: key);

  @override
  _OrgCasesScreenState createState() => _OrgCasesScreenState();
}

class _OrgCasesScreenState extends State<OrgCasesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/background.png'), fit: BoxFit.cover),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: kToolbarHeight + 10,
            ),
            Text(
              'Cases History',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: smartYellow,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Container(
              height: 1,
              width: 200,
              color: Colors.white,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("cases")
                    .orderBy('timestamp', descending: true)
                    .where('orgId', isEqualTo: widget.orgId)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError)
                    return new Text('Error: ${snapshot.error}');
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return CircularProgress();
                    default:
                      return new ListView(
                        children: snapshot.data.docs
                            .map(
                              (doc) => BlackLocationCell(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  textColor: Colors.white,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        doc.get("ordName"),
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Color(0xFFF7EC03),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        doc.get('caseType'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Case: ' + doc.get('caseDescription'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Case No. ' + doc.get('caseNumber'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        doc.get('locationName'),
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        getDate(doc.get('timestamp')),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      doc.get('referredBy') != '0'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Reffered by",
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Text(
                                                    doc.get('referredByName'),
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _statusWidget(
                                            status: doc.get('status')),
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  borderRadius: 10,
                                  func: () {
                                    if (doc.get('status') == 0) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                          elevation: 30,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(10))),
                                          title: Text(
                                            'Do you want to Close this Case?',
                                            style: TextStyle(
                                              fontSize: 16,
                                            ),
                                          ),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('No'),
                                            ),
                                            FlatButton(
                                              onPressed: () =>
                                                  _onClose(doc.id),
                                              child: Text('Yes'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }),
                            )
                            .toList(),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String getDate(Timestamp timestamp) {
    var dt = DateTime.fromMicrosecondsSinceEpoch(
        timestamp.millisecondsSinceEpoch * 1000);
    return "${dt.day}-${dt.month}-${dt.year} ${dt.hour}:${dt.minute}";
  }

  Widget _statusWidget({int status}) {
    Color bgColor = Colors.green;
    Color textColor = Colors.white;
    String text = 'Active';

    switch (status) {
      case 0:
        bgColor = Colors.green;
        textColor = Colors.white;
        text = 'Active';
        break;
      case 1:
        bgColor = Colors.red;
        textColor = Colors.white;
        text = 'Closed';
        break;
    }
    return Container(
      height: 30,
      width: 90,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        color: bgColor,
        boxShadow: [
          BoxShadow(
            color: bgColor,
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: FittedBox(
            child: Text(
          text,
          style: TextStyle(color: textColor),
        )),
      ),
      padding: EdgeInsets.all(4),
    );
  }

  _onClose(String caseId) {
    Navigator.pop(context);
    showLoading(message: 'Closing Case...', context: context);
    try {
      FirebaseFirestore.instance
          .collection('cases')
          .doc(caseId)
          .update({'status': 1}).then((onValue) {
        Navigator.pop(context);
        showAction(
          actionText: 'OK',
          text: 'Case Closed Successfully!',
          func: () => Navigator.pop(context),
          context: context,
        );
      });
    } catch (error) {
      Navigator.pop(context);
      showAction(
        actionText: 'OK',
        text: 'Case Closing Failed!',
        func: () => Navigator.pop(context),
        context: context,
      );
    }
  }
}
