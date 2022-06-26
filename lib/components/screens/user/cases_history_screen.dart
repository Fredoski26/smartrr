import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/models/case.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:smartrr/generated/l10n.dart';

class CasesHistoryScreen extends StatefulWidget {
  @override
  _CasesHistoryScreenState createState() => _CasesHistoryScreenState();
}

class _CasesHistoryScreenState extends State<CasesHistoryScreen> {
  bool _isLoading = true;
  List<Case> _casesList = <Case>[];

  @override
  void initState() {
    _getDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_language.history)),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        child: _isLoading
            ? CircularProgress()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 31),
                  _casesList.length == 0
                      ? Text(
                          'No Cases Filed Yet',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : Expanded(
                          child: ListView.separated(
                            separatorBuilder: (context, i) => Divider(),
                            itemCount: _casesList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                minLeadingWidth: 10.0,
                                leading: Text("${index + 1}"),
                                title: Text(
                                  "${_casesList[index].caseDesc}",
                                  overflow: TextOverflow.ellipsis,
                                ),
                                subtitle: Text(
                                  "Org: ${_casesList[index].orgName} \n ${getDate(_casesList[index].timestamp)}",
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                ),
                                trailing: _statusWidget(
                                    status: _casesList[index].status),
                                isThreeLine: true,
                              );
                            },
                          ),
                        ),
                ],
              ),
      ),
    );
  }

  _updateCaseUserId({@required String oldUId, @required newUId}) async {
    FirebaseFirestore.instance
        .collection("cases")
        .where("userId", isEqualTo: oldUId)
        .get()
        .then((docs) {
      final batch = FirebaseFirestore.instance.batch();

      docs.docs.forEach((doc) {
        var docRef = FirebaseFirestore.instance.collection("cases").doc(doc.id);

        HashMap<String, Object> update = HashMap.from({"userId": newUId});

        batch.set(docRef, update, SetOptions(merge: true));
      });

      batch.commit().then((_) => print("All documents updated"));
    });
  }

  _logout() async {
    await FirebaseAuth.instance.signOut().then((_) {
      clearPrefs().then((_) => Navigator.pushNamedAndRemoveUntil(
          context, '/login', ModalRoute.withName('Login')));
    });
  }

  _getDataFromFirebase() async {
    String userId = await getUserIdPref();
    String userDocId = await getUserDocIdPref();

// logout user if no user doc id
    if (userDocId == null || (userDocId != null && userDocId.isEmpty))
      return _logout();

    await _updateCaseUserId(oldUId: userDocId, newUId: userId);
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
                victimAge: cases.docs[i].get("victimAge") != null
                    ? int.tryParse(cases.docs[i].get('victimAge').toString())
                    : null,
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
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(14)),
        color: bgColor,
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
