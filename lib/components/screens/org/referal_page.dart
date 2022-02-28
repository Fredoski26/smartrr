import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/models/case.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/text_box.dart';
import 'case_file_page.dart';

class ReferralPage extends StatefulWidget {
  @override
  _ReferralPageState createState() => _ReferralPageState();
}

class _ReferralPageState extends State<ReferralPage> {
  bool acceptedValue = false;
  List<Case> _casesList = new List<Case>();
  List<DropdownMenuItem<Case>> _dropDownCaseItem = [];
  Case _currentCase;
  bool _isLoading = true;

  @override
  void initState() {
    _getDataFromFirebase();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: _isLoading ? CircularProgress()
            :
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight + 10,
            ),
            Text(
              'Refer',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: smartYellow,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Select Case File',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            Text(
              'Case File Number',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            DropdownButton(
              isExpanded: true,
              items: _dropDownCaseItem,
              value: _currentCase,
              onChanged: (Case value) {
                setState(() => _currentCase = value);
              },
              dropdownColor: Colors.black,
              hint: Text(
                'Select Case File No.',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              style: TextStyle(fontSize: 16, color: Colors.white),
              elevation: 1,
              underline: SizedBox(),
              icon: Icon(Icons.keyboard_arrow_down, color: Colors.white,),
            ),
            SizedBox(
              height: 40,
            ),
            Center(
              child: GestureDetector(
                child: Card(
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
                  ),
                ),
                onTap: () {
                  if (_currentCase != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (BuildContext context) =>
                            CaseFilePage(
                              caseFile: _currentCase,
                            ),
                      ),
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "Please select Case File Number",
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
            ),
          ],
        ),
      ),
    );
  }

  _getDataFromFirebase() async {
    String orgId = await getOrgIdPref();
    await FirebaseFirestore.instance
        .collection("cases")
        .where('orgId', isEqualTo: orgId)
        .where('status', isEqualTo: 0)
        .get().then((cases) {
      for (int i = 0; i < cases.docs.length; i++) {
        if (mounted) {
          setState(
                () =>
                _casesList.add(
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
                  ),
                ),
          );
        }
      }
      _dropDownCaseItem = buildDropDownStateItems(_casesList);
      setState(() => _isLoading = false);
    });
  }

  List<DropdownMenuItem<Case>> buildDropDownStateItems(List<Case> list) {
    List<DropdownMenuItem<Case>> items = List();
    for (Case item in list) {
      items.add(
        DropdownMenuItem(
          value: item,
          child: Text(item.caseNumber),
        ),
      );
    }
    return items;
  }
}
