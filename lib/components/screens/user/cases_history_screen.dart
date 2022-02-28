import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/selected_location_cell.dart';
import 'package:smartrr/models/case.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';

class CasesHistoryScreen extends StatefulWidget {
  @override
  _CasesHistoryScreenState createState() => _CasesHistoryScreenState();
}

class _CasesHistoryScreenState extends State<CasesHistoryScreen> {
  bool _isLoading = true;
  List<Case> _casesList = new List<Case>();

  @override
  void initState() {
    _getDataFromFirebase();
    super.initState();
  }

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
        child: _isLoading
            ? CircularProgress()
            : Column(
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
                  _casesList.length == 0
                      ? Text(
                          'No Cases Filed Yet',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            itemCount: _casesList.length,
                            itemBuilder: (context, index) {
                              return BlackLocationCell(
                                  width:
                                      MediaQuery.of(context).size.width * 0.9,
                                  textColor: Colors.white,
                                  bgColor: dropDownCanvasDarkColor,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        _casesList[index].orgName,
                                        textAlign: TextAlign.start,
                                        maxLines: 2,
                                        style: TextStyle(
                                            color: Color(0xFFF7EC03),
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        _casesList[index].caseType,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        'Case: ' + _casesList[index].caseDesc,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      _casesList[index].isVictim
                                          ? Text(
                                              'Victim: ' +
                                                  _casesList[index].victimName,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : Container(),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        _casesList[index].locationName,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        getDate(_casesList[index].timestamp),
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: _statusWidget(
                                            status: _casesList[index].status),
                                      ),
                                    ],
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                  ),
                                  borderRadius: 10,
                                  func: () {
                                    debugPrint('Case Tapped');
                                  });
                            },
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  _getDataFromFirebase() async {
    String userId = await getUserIdPref();
    await FirebaseFirestore.instance
        .collection("cases")
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get()
        .then((cases) {
      for (int i = 0; i < cases.docs.length; i++) {
        if (mounted) {
          setState(
            () => _casesList.add(
              Case(
                id: cases.docs[i].id,
                orgId: cases.docs[i].get('orgId'),
                orgName: cases.docs[i].get('orgName'),
                caseType: cases.docs[i].get('caseType'),
                userId: cases.docs[i].get('userId'),
                locationName: cases.docs[i].get('locationName'),
                status: cases.docs[i].get('status'),
                caseDesc: cases.docs[i].get('caseDescription'),
                caseNumber: cases.docs[i].get('caseNumber'),
                locationId: cases.docs[i].get('locationId'),
                referredBy: cases.docs[i].get('referredBy'),
                referredByName: cases.docs[i].get('referredByName'),
                timestamp: cases.docs[i].get('timestamp'),
                isVictim: cases.docs[i].get('isVictim'),
                victimAge: cases.docs[i].get('victimAge'),
                victimGender: cases.docs[i].get('victimGender'),
                victimName: cases.docs[i].get('victimName'),
                victimPhone: cases.docs[i].get('victimPhone'),
              ),
            ),
          );
        }
      }
//      _casesList.sort((a, b) => a.doc.compareTo(b.doc));
      setState(() => _isLoading = false);
    });
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
}
