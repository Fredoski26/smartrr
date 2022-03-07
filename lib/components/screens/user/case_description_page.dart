import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/my_stepper.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/models/organization.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/selected_location_cell.dart';
import 'report_or_history_page.dart';

class CaseDescriptionPage extends StatefulWidget {
  final Organization org;
  final MyLocation state;
  final MyLocation location;
  final String service;

  const CaseDescriptionPage({
    Key key,
    @required this.org,
    @required this.state,
    @required this.location,
    @required this.service,
  }) : super(key: key);

  @override
  _CaseDescriptionPageState createState() => _CaseDescriptionPageState();
}

class _CaseDescriptionPageState extends State<CaseDescriptionPage> {
  bool acceptedValue = false;
  bool _isLoading = true;
  bool _isMale = true;
  bool _userType = true;
  User currentUser;
  String selectedDescription;
  TextEditingController _name = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _cnic = TextEditingController();
  TextEditingController _age = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> currentUserInfo = Map<String, dynamic>();

  @override
  void initState() {
    _getUserType();
    super.initState();
    User _currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      currentUser = _currentUser;
    });

    FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: _currentUser.email)
        .get()
        .then((docsReturned) {
      var returnedUserInfo = docsReturned.docs[0].data();
      setState(() {
        currentUserInfo = returnedUserInfo;
        _isLoading = false;
      });
    });
  }

  final List<String> items = [
    'Female Genital Mutilation',
    'Physical Abuse',
    'Rape',
    'Sexual Abuse',
    'Psychological/Emotional Abuse',
    'Forced/child marriage',
    'Denial of resources',
    'Sexual Exploitation & Abuse'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select Case Description")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        child: _isLoading
            ? CircularProgress()
            : _userType
                ? Column(mainAxisSize: MainAxisSize.min, children: [
                    Text(
                      '${widget.org.name}',
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, i) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            leading: Radio(
                                value: items[i],
                                groupValue: selectedDescription,
                                onChanged: (val) => {
                                      setState(() {
                                        selectedDescription = val;
                                      })
                                    }),
                            title: Text(items[i]),
                          );
                        },
                        itemCount: items.length,
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: TextButton(
                          onPressed: _saveCase,
                          child: Text(
                            "Submit Report",
                          ),
                        ))
                      ],
                    )
                  ])
                // ? Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       MyStepper(activeIndex: 5),
                //       SizedBox(height: 31),
                //       Text(
                //         '${widget.org.name}',
                //         textAlign: TextAlign.center,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: TextStyle(
                //           fontSize: 30,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       SizedBox(height: 20),
                //       ListView.builder(
                //         itemBuilder: (context, i) {
                //           return ListTile(
                //             contentPadding: EdgeInsets.zero,
                //             leading: Radio(
                //                 value: items[i],
                //                 groupValue: _value,
                //                 onChanged: (val) => {
                //                       setState(() {
                //                         _value = val;
                //                       })
                //                     }),
                //             title: Text("Select"),
                //           );
                //         },
                //         itemCount: items.length,
                //       ),
                //       Theme(
                //         data: ThemeData(
                //           canvasColor: dropDownCanvasColor,
                //         ),
                //         child: BlackLocationCell(
                //           borderRadius: 12,
                //           verticalPadding: 4,
                //           child: DropdownButton<String>(
                //             isExpanded: true,
                //             value: selectedDescription,
                //             hint: Text(
                //               'Select One',
                //               style: TextStyle(color: Colors.grey),
                //             ),
                //             icon: Icon(Icons.keyboard_arrow_down),
                //             underline: SizedBox(),
                //             style: TextStyle(color: Colors.black),
                //             items: items.map((String value) {
                //               return new DropdownMenuItem<String>(
                //                 value: value,
                //                 child: new Text(
                //                   value,
                //                   style: TextStyle(color: Colors.black),
                //                 ),
                //               );
                //             }).toList(),
                //             onChanged: (value) =>
                //                 setState(() => selectedDescription = value),
                //           ),
                //         ),
                //       ),
                //     ],
                //   )
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${widget.org.name}',
                            textAlign: TextAlign.center,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 50,
                          ),
                          Text(
                            'Case Type',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Theme(
                            data: ThemeData(
                              canvasColor: dropDownCanvasColor,
                            ),
                            child: BlackLocationCell(
                              borderRadius: 12,
                              verticalPadding: 4,
                              child: DropdownButton<String>(
                                isExpanded: true,
                                value: selectedDescription,
                                hint: Text(
                                  'Select One',
                                  style: TextStyle(color: Colors.grey),
                                ),
                                icon: Icon(Icons.keyboard_arrow_down),
                                underline: SizedBox(),
                                style: TextStyle(color: Colors.black),
                                items: items.map((String value) {
                                  return new DropdownMenuItem<String>(
                                    value: value,
                                    child: new Text(
                                      value,
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    setState(() => selectedDescription = value),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 18,
                          ),
                          smartTextField(
                            title: 'Name',
                            controller: _name,
                            isForm: true,
                          ),
                          smartTextField(
                            title: 'Age',
                            controller: _age,
                            isForm: true,
                            textInputType: TextInputType.number,
                          ),
                          smartTextField(
                            title: 'Phone No.',
                            controller: _phone,
                            isPhone: true,
                            prefix: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 4),
                              child: Text(
                                '+234',
                                style: TextStyle(
                                  color: lightGrey,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            isForm: true,
                            textInputType: TextInputType.phone,
                          ),
                          smartTextField(
                            title: 'National ID Card No.',
                            controller: _cnic,
                            isForm: false,
                            required: false,
                            textInputType: TextInputType.number,
                          ),
                          Text(
                            'Gender',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_isMale)
                                    setState(() => _isMale = false);
                                  else
                                    setState(() => _isMale = true);
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _isMale,
                                      onChanged: (val) {
                                        print('===> $val');
                                        if (val)
                                          setState(() => _isMale = true);
                                        else
                                          setState(() => _isMale = false);
                                      },
                                    ),
                                    Text(
                                      'Male',
                                    ),
                                  ],
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (_isMale)
                                    setState(() => _isMale = false);
                                  else
                                    setState(() => _isMale = true);
                                },
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: !_isMale,
                                      onChanged: (val) {
                                        print('===> $val');
                                        if (val)
                                          setState(() => _isMale = false);
                                        else
                                          setState(() => _isMale = true);
                                      },
                                    ),
                                    Text(
                                      'Female',
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 80,
                          ),
                          Row(
                            children: [
                              Expanded(
                                  child: TextButton(
                                child: Text("Submit Report"),
                                onPressed: _saveCaseWithUser,
                              ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }

  _caseRegistered() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ReportOrHistoryPage(),
      ),
      ModalRoute.withName('/'),
    );
  }

//  void _sendMail() {
//    bool done = false;
//    print("Email to send to: ${widget.emailAddress}");
//    var messageText =
//        'Dear SP, \nBe notify that a case that concerns your area of specialty has been reported to you. Kindly respond accordingly.\n\nCase File number: $caseNo\nEmail Address: ${currentUserInfo['email']}\nPhone Number: ${currentUserInfo['phoneNumber']}\nLocation: ${currentUserInfo['location']}';
//    if (widget.emailAddress != '') {
//      var message = Message()
//        ..from = Address(currentUserInfo['email'], 'SmartRR')
//        //..recipients.add(widget.emailAddress)
//        ..recipients.add(widget.emailAddress)
//        ..recipients.add('oguntoyebenjamin2@gmail.com')
//        ..recipients.add('sharjeela35@gmail.com')
//        ..subject = 'Report from SmartRR'
//        ..text = messageText;
//
//      try {
//        print("Before sending");
//        send(message, smtpServer).then((sendReport) {
//          done = true;
//          incrementCaseNo();
//          print("after sending");
//          print(caseNo);
//        });
//      } on MailerException catch (e) {
//        done = false;
//      }
//    }
//    if (widget.phoneNummber != '') {
//      done = true;
//      var finalPhoneNumber = widget.phoneNummber;
//      print('Final phone number: $finalPhoneNumber');
//      ApiClient()
//          .sendSMS(finalPhoneNumber, messageText)
//          .then((returnedResponse) {
//        print("Response from text: $returnedResponse");
//      });
//    }
//    print('done value: $done');
//    if (done) {
//      showAction(
//          actionText: 'OK',
//          text: 'Case Registered Successfully!',
//          func: _caseRegistered,
//          context: context);
//    } else {
//      showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return AlertDialog(
//            content: Container(
//              child: Text('Message not sent'),
//            ),
//          );
//        },
//      );
//    }
//  }

  void _showException({@required String errorMsg}) {
    showAction(
      actionText: 'OK',
      text: errorMsg,
      func: () => Navigator.pop(context),
      context: context,
    );
  }

  Future _saveCase() async {
    if (selectedDescription != null) {
      setState(() => _isLoading = true);
      String userId = await getUserIdPref();
      String caseNumber = '';
      List<String> ll = currentUser.displayName.split(' ');
      for (int i = 0; i < ll.length; i++) {
        caseNumber += ll[i].substring(0, 1);
      }
      caseNumber =
          "$caseNumber${DateTime.now().millisecondsSinceEpoch}${widget.service.substring(0, 1)}";
      try {
        FirebaseFirestore.instance.collection('cases').doc().set({
          'caseNumber': caseNumber,
          'userId': userId,
          'orgId': widget.org.id,
          'orgName': widget.org.name,
          'orgEmail': widget.org.orgEmail,
          'caseType': widget.service,
          'caseDescription': selectedDescription,
          'focalPhone': widget.org.focalPhone,
          'locationId': widget.location.id,
          'locationName': "${widget.location.title}, ${widget.state.title}",
          'timestamp': DateTime.now(),
          'status': 0,
          'referredBy': "0",
          'referredByName': widget.org.name,
          'isVictim': false,
          'victimName': null,
          'victimAge': null,
          'victimPhone': null,
          'victimGender': null
        }).then((onValue) {
          showAction(
            actionText: 'OK',
            text: 'Case Registered Successfully!',
            func: _caseRegistered,
            context: context,
          );
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showException(errorMsg: 'Please check your network!');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please Select Case Description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  Future _saveCaseWithUser() async {
    if (selectedDescription != null) {
      setState(() => _isLoading = true);
      String userId = await getUserIdPref();
      String caseNumber = '';
      List<String> ll = currentUser.displayName.split(' ');
      for (int i = 0; i < ll.length; i++) {
        caseNumber += ll[i].substring(0, 1);
      }
      caseNumber =
          "$caseNumber${DateTime.now().millisecondsSinceEpoch}${widget.service.substring(0, 1)}";
      try {
        FirebaseFirestore.instance.collection('cases').doc().set({
          'caseNumber': caseNumber,
          'userId': userId,
          'orgId': widget.org.id,
          'orgName': widget.org.name,
          'orgEmail': widget.org.orgEmail,
          'focalPhone': widget.org.focalPhone,
          'caseType': widget.service,
          'caseDescription': selectedDescription,
          'locationId': widget.location.id,
          'locationName': "${widget.location.title}, ${widget.state.title}",
          'timestamp': DateTime.now(),
          'status': 0,
          'referredBy': "0",
          'referredByName': widget.org.name,
          'isVictim': true,
          'victimName': _name.text,
          'victimAge': double.parse(_age.text),
          'victimPhone': "234${_phone.text}",
          'victimCnic': _cnic.text.toString(),
          'victimGender': _isMale
        }).then((onValue) {
          showAction(
            actionText: 'OK',
            text: 'Case Registered Successfully!',
            func: _caseRegistered,
            context: context,
          );
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showException(errorMsg: 'Please check your network!');
      }
    } else {
      Fluttertoast.showToast(
        msg: "Please Select Case Description",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black54.withOpacity(0.3),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  void _getUserType() async {
    _userType = await getUserTypePref();
  }
}
