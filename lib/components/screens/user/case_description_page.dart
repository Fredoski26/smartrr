import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/report_or_history_page.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/models/organization.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:smartrr/services/api_client.dart';

class CaseDescriptionPage extends StatefulWidget {
  final Organization org;
  final MyLocation state;
  final MyLocation location;
  final String service;

  const CaseDescriptionPage({
    super.key,
    required this.org,
    required this.state,
    required this.location,
    required this.service,
  });

  @override
  _CaseDescriptionPageState createState() => _CaseDescriptionPageState();
}

class _CaseDescriptionPageState extends State<CaseDescriptionPage> {
  bool acceptedValue = false;
  bool _isLoading = true;
  bool _isMale = true;
  bool _userType = true;
  late User currentUser;
  String? selectedDescription = null;
  TextEditingController _name = TextEditingController();
  TextEditingController _cnic = TextEditingController();
  TextEditingController _age = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> currentUserInfo = Map<String, dynamic>();

  @override
  void initState() {
    _getUserType();
    super.initState();
    User _currentUser = FirebaseAuth.instance.currentUser!;
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
    S.current.fgm,
    S.current.physicalAbuse,
    S.current.rape,
    S.current.sexualAbuse,
    S.current.psychologicalOrEmotionalAbuse,
    S.current.forcedMarriage,
    S.current.denialOfResources,
    S.current.sexualReproductiveKits
  ];

  @override
  Widget build(BuildContext context) {
    final _language = S.current;

    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
              appBar: AppBar(title: Text(_language.selectCaseDescription)),
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
                                    onTap: () {
                                      setState(() {
                                        selectedDescription = items[i];
                                      });
                                    },
                                    leading: Radio(
                                        value: items[i],
                                        groupValue: selectedDescription,
                                        onChanged: (String? val) => {
                                              setState(() {
                                                selectedDescription = val!;
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
                                  onPressed: () =>
                                      _saveCase(lang: langNotifier.locale),
                                  child: Text(
                                    _language.submitReport,
                                  ),
                                ))
                              ],
                            )
                          ])
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
                                    height: 20,
                                  ),
                                  DropdownButtonFormField(
                                    isExpanded: true,
                                    value: selectedDescription,
                                    hint: Text(
                                      _language.caseType,
                                      style: Theme.of(context)
                                          .inputDecorationTheme
                                          .hintStyle,
                                    ),
                                    icon: Icon(Icons.keyboard_arrow_down),
                                    items: items.map((String value) {
                                      return new DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) => setState(
                                        () => selectedDescription = value!),
                                    decoration: InputDecoration().copyWith(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 25.0, vertical: 6.0),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide:
                                              BorderSide(color: lightGrey)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide:
                                              BorderSide(color: lightGrey)),
                                      errorBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(50)),
                                          borderSide:
                                              BorderSide(color: Colors.red)),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 18,
                                  ),
                                  smartTextField(
                                    title: _language.name,
                                    controller: _name,
                                    isForm: true,
                                  ),
                                  smartTextField(
                                    title: _language.age,
                                    controller: _age,
                                    isForm: true,
                                    textInputType: TextInputType.number,
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25.0, vertical: 0),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(50.0)),
                                        border: Border.all(
                                            width: 1, color: lightGrey)),
                                    child: InternationalPhoneNumberInput(
                                      onInputChanged: (PhoneNumber val) {
                                        number = val;
                                      },
                                      selectorConfig: SelectorConfig(
                                        selectorType:
                                            PhoneInputSelectorType.BOTTOM_SHEET,
                                      ),
                                      selectorTextStyle: Theme.of(context)
                                          .inputDecorationTheme
                                          .hintStyle,
                                      initialValue: number,
                                      textFieldController:
                                          phoneNumberController,
                                      inputBorder: InputBorder.none,
                                      selectorButtonOnErrorPadding: 0,
                                      spaceBetweenSelectorAndTextField: 0,
                                    ),
                                  ),
                                  SizedBox(height: 20.0),
                                  smartTextField(
                                    title: 'National ID Card No.',
                                    controller: _cnic,
                                    isForm: false,
                                    required: false,
                                    textInputType: TextInputType.number,
                                  ),
                                  Text(
                                    _language.gender,
                                    style: TextStyle(
                                      fontSize: 18,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                                if (val!)
                                                  setState(
                                                      () => _isMale = true);
                                                else
                                                  setState(
                                                      () => _isMale = false);
                                              },
                                            ),
                                            Text(
                                              _language.male,
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
                                                if (val!)
                                                  setState(
                                                      () => _isMale = false);
                                                else
                                                  setState(
                                                      () => _isMale = true);
                                              },
                                            ),
                                            Text(
                                              _language.female,
                                            ),
                                          ],
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
                                          child: TextButton(
                                        child: Text(_language.submitReport),
                                        onPressed: _saveCaseWithUser,
                                      ))
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
              ),
            ));
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

  void _showException({required String errorMsg}) {
    showAction(
      actionText: 'OK',
      text: errorMsg,
      func: () => Navigator.pop(context),
      context: context,
    );
  }

  Future _saveCase({String lang = "en"}) async {
    final language = S.current;

    if (selectedDescription != null) {
      setState(() => _isLoading = true);
      String userId = await getUserIdPref();
      String caseNumber = '';
      List<String> ll = currentUser.displayName!.split(' ');
      for (int i = 0; i < ll.length; i++) {
        caseNumber += ll[i].substring(0, 1);
      }
      caseNumber =
          "$caseNumber${DateTime.now().millisecondsSinceEpoch}${widget.service.substring(0, 1)}";
      String phoneNumber = currentUserInfo['phoneNumber'];

      try {
        String orgSmsMsg = """Dear ${widget.org.name}, 
            \n Be notified that a case concerning your area of specialty (${widget.service}) has been reported to you. Kindly respond accordingly. 
            \n\n CASE INFO: 
            \n Case Number: $caseNumber 
            \n Case Description: $selectedDescription 
            \n Phone Number: $phoneNumber
            \n Location: ${widget.location.title}, ${widget.state.title} """;

        await ApiClient().sendSMS(
          phoneNumber: widget.org.focalPhone!,
          message: orgSmsMsg,
        );

        FirebaseFirestore.instance.collection('cases').doc().set({
          'language': lang,
          'caseNumber': caseNumber,
          'userId': userId,
          'orgId': widget.org.id,
          'orgName': widget.org.name,
          'orgEmail': widget.org.orgEmail,
          'focalPhone': currentUser.phoneNumber,
          'caseType': widget.service,
          'caseDescription': selectedDescription,
          'locationId': widget.location.id,
          "location": widget.location.title,
          'locationName': "${widget.location.title}, ${widget.state.title}",
          'timestamp': DateTime.now(),
          'status': 0,
          'referredBy': "0",
          'referredByName': widget.org.name,
          'isVictim': true,
          'victimName': null,
          'victimAge': null,
          'victimPhone': currentUserInfo["phoneNumber"],
          'victimGender': currentUserInfo["gender"]
        }).then((onValue) {
          showAction(
            actionText: 'OK',
            text: language.caseRegisteredSuccesfully,
            func: _caseRegistered,
            context: context,
          );
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showException(errorMsg: language.badInternet);
      }
    } else {
      Fluttertoast.showToast(
        msg: language.selectDescription,
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
    final _language = S.current;

    if (selectedDescription != null) {
      setState(() => _isLoading = true);
      String userId = await getUserIdPref();
      String caseNumber = '';
      List<String> ll = currentUser.displayName!.split(' ');
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
          'focalPhone': currentUser.phoneNumber,
          'caseType': widget.service,
          'caseDescription': selectedDescription,
          'locationId': widget.location.id,
          "location": widget.location.title,
          'locationName': "${widget.location.title}, ${widget.state.title}",
          'timestamp': DateTime.now(),
          'status': 0,
          'referredBy': "0",
          'referredByName': widget.org.name,
          'isVictim': false,
          'victimName': _name.text,
          'victimAge': int.parse(_age.text),
          'victimPhone': number.phoneNumber,
          'victimCnic': _cnic.text.toString(),
          'victimGender': _isMale
        }).then((onValue) {
          showAction(
            actionText: 'OK',
            text: _language.caseRegisteredSuccesfully,
            func: _caseRegistered,
            context: context,
          );
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        _showException(errorMsg: _language.badInternet);
      }
    } else {
      Fluttertoast.showToast(
        msg: _language.selectDescription,
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
