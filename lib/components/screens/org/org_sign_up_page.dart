import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/utils/colors.dart';
import '../../widgets/ask_action.dart';
import '../../widgets/show_action.dart';
import '../../widgets/show_loading.dart';
import '../../widgets/smart_text_field.dart';
import '../../../models/services.dart';

class OrgSignUpPage extends StatefulWidget {
  @override
  _OrgSignUpPageState createState() => _OrgSignUpPageState();
}

class _OrgSignUpPageState extends State<OrgSignUpPage> {
  int _stepIndex = 0;
  int _maxSteps = 6;

  final _formKey = GlobalKey<FormState>();
  TextEditingController cName = TextEditingController();
  TextEditingController cType = TextEditingController();
  TextEditingController cTelephone = TextEditingController();
  TextEditingController cOrgEmail = TextEditingController();
  TextEditingController cPassword = TextEditingController();
  TextEditingController cLanguage = TextEditingController();
  TextEditingController cLga = TextEditingController();
  TextEditingController cWard = TextEditingController();
  TextEditingController cSite = TextEditingController();
  TextEditingController cStartDate = TextEditingController();
  TextEditingController cEndDate = TextEditingController();
  TextEditingController cStartTime = TextEditingController();
  TextEditingController cCloseTime = TextEditingController();
  TextEditingController cFocalName = TextEditingController();
  TextEditingController cFocalEmail = TextEditingController();
  TextEditingController cFocalPhone = TextEditingController();
  TextEditingController cFocalDesignation = TextEditingController();
  TextEditingController cHow = TextEditingController();
  TextEditingController cCriteria = TextEditingController();
  TextEditingController cComments = TextEditingController();

  String errorMsg;
  double _hPadding = 18.0;
  bool isLoading = false;
  List<Services> servicesList = <Services>[];
  List<String> _selectedServicesList = [];

  // States
  List<MyLocation> stateList = <MyLocation>[];
  List<DropdownMenuItem<MyLocation>> _dropDownStateItem = [];
  MyLocation _currentState;

  // Locations
  List<MyLocation> locationsList = <MyLocation>[];
  List<DropdownMenuItem<MyLocation>> _dropDownLocationItem = [];
  MyLocation _currentLocation;

  @override
  void initState() {
    _getDataFromFirebase();
    _getStatesFromFirebase();
    super.initState();
  }

  Future<bool> _askAlertWill() async {
    if (_stepIndex == 0) {
      _askOut();
    } else {
      _decreaseStackIndex();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _askAlertWill,
      child: Container(
        decoration: BoxDecoration(color: Colors.white),
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              leading: IconButton(
                  icon: Icon(Icons.arrow_back), onPressed: () => _askOut()),
              actions: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      'Step ${_stepIndex + 1} of ${_maxSteps + 1}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
            persistentFooterButtons: [
              Container(
                width: size.width,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _decreaseStackIndex,
                        child: Text(
                          'Back',
                          style: TextStyle(
                            color: primaryColor,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: _increaseStackIndex,
                        child: Text(
                          'Next',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            body: Container(
              child: Stack(children: [
                Positioned(
                  top: -208,
                  child: Container(
                    height: 332.0,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(90),
                            bottomLeft: Radius.circular(90))),
                  ),
                ),
                Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 60),
                          padding: EdgeInsets.all(30),
                          width: 318,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xFF494949).withOpacity(0.5),
                                offset: Offset(0, 30),
                                blurRadius: 122,
                              )
                            ],
                          ),
                          child: AnimatedSwitcher(
                              duration: Duration(milliseconds: 500),
                              transitionBuilder:
                                  (Widget child, Animation<double> animation) =>
                                      ScaleTransition(
                                          child: child, scale: animation),
                              child: IndexedStack(
                                key: ValueKey<int>(_stepIndex),
                                index: _stepIndex,
                                children: [
                                  _stack1(),
                                  _projectSpan(),
                                  _workHours(),
                                  _focalPerson(),
                                  _services(),
                                  _details(),
                                  _locations(),
                                ],
                              )),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 109.0,
                          width: 109.0,
                          margin: EdgeInsets.only(top: 0.0),
                          child: Image.asset("assets/logo.png"),
                        ),
                      ],
                    ),
                  ],
                )
              ]),
            )),
      ),
    );
  }

  void _submit() async {
    showLoading(message: 'Checking Information...', context: context);
    try {
      UserCredential authResult = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: cOrgEmail.text, password: cPassword.text);
      var displayName = "";
      displayName = cName.text;
      Navigator.pop(context);
      showLoading(message: 'Registering...', context: context);
      authResult.user.updateDisplayName(displayName).then((onValue) async {
        await FirebaseFirestore.instance.collection('organizations').doc().set({
          'name': cName.text,
          'type': cType.text,
          'telephone': cTelephone.text,
          'orgEmail': cOrgEmail.text,
          'password': cPassword.text,
          'language': cLanguage.text,
          'lga': cLga.text,
          'ward': cWard.text,
          'site': cSite.text,
          'startDate': cStartDate.text,
          'endDate': cEndDate.text,
          'startTime': cStartTime.text,
          'closeTime': cCloseTime.text,
          'focalName': cFocalName.text,
          'focalEmail': cFocalEmail.text,
          'focalPhone': '234${cFocalPhone.text}',
          'focalDesignation': cFocalDesignation.text,
          'how': cHow.text,
          'criteria': cCriteria.text,
          'comments': cComments.text,
          'servicesAvailable': FieldValue.arrayUnion(_selectedServicesList),
          'status': 0,
          'locationId': _currentLocation.id,
          'uId': authResult.user.uid,
        }).then((onValue) {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          showAction(
            actionText: 'OK',
            text: "You'll get Approval Email Soon",
            func: _goBack,
            context: context,
          );
          debugPrint("I am back ===> }");
        });
      });
    } catch (error) {
      Navigator.pop(context);
      switch (error.code) {
        case "ERROR_EMAIL_ALREADY_IN_USE":
          {
            setState(() {
              errorMsg = "This email is already in use.";
            });
            showAction(
              actionText: 'OK',
              text: errorMsg,
              func: () => Navigator.pop(context),
              context: context,
            );
          }
          break;
        case "ERROR_WEAK_PASSWORD":
          {
            setState(() {
              errorMsg = "The password must be 6 characters long or more.";
            });
            showAction(
              actionText: 'OK',
              text: errorMsg,
              func: () => Navigator.pop(context),
              context: context,
            );
          }
          break;
        default:
          {
            setState(() {
              errorMsg = "";
            });
          }
      }
    }
  }

  _increaseStackIndex() {
    if (_stepIndex < _maxSteps) {
      if (_stepIndex == 0) {
        final FormState form = _formKey.currentState;
        if (_formKey.currentState.validate()) {
          form.save();
          debugPrint('Index Increased');
          setState(() => _stepIndex++);
        }
      } else if (_stepIndex == 4) {
        if (_selectedServicesList.isEmpty) {
          Fluttertoast.showToast(
            msg: "Please Select Services",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black54.withOpacity(0.3),
            textColor: Colors.white,
            fontSize: 16.0,
          );
        } else {
          debugPrint('Index Increased');
          setState(() => _stepIndex++);
        }
      } else {
        debugPrint('Index Increased');
        setState(() => _stepIndex++);
      }
    } else {
      if (_currentState == null || _currentLocation == null) {
        Fluttertoast.showToast(
          msg: "Please Select State/Location",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black54.withOpacity(0.3),
          textColor: Colors.white,
          fontSize: 16.0,
        );
      } else {
        askAction(
          actionText: 'Yes',
          cancelText: 'No',
          text: 'Do you want to Submit?',
          context: context,
          func: () {
            Navigator.pop(context);
            _submit();
          },
          cancelFunc: () => Navigator.pop(context),
        );
      }
    }
  }

  _decreaseStackIndex() {
    if (_stepIndex > 0) {
      debugPrint('Index Decreased');
      setState(() => _stepIndex--);
    } else if (_stepIndex == 0) {
      debugPrint('Navigtaor POP called');
      _askOut();
    } else {
      debugPrint('Index hi Index ayy');
    }
  }

  _stack1() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'REGISTER',
                style: TextStyle(
                  color: Color(0xFF444444),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              smartTextField(
                title: 'Organization Name',
                controller: cName,
                isForm: true,
              ),
              smartTextField(
                title: 'Type of Organization',
                controller: cType,
              ),
              smartTextField(
                title: 'Telephone',
                controller: cTelephone,
                textInputType: TextInputType.phone,
              ),
              smartTextField(
                title: 'Organization Email',
                controller: cOrgEmail,
                textInputType: TextInputType.emailAddress,
                isForm: true,
              ),
              smartTextField(
                title: 'Password',
                controller: cPassword,
                obscure: true,
                isForm: true,
              ),
              smartTextField(
                title: 'Major Language',
                controller: cLanguage,
              ),
              smartTextField(
                title: 'LGA',
                controller: cLga,
              ),
              smartTextField(
                title: 'Ward',
                controller: cWard,
              ),
              smartTextField(
                title: 'Site',
                controller: cSite,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _projectSpan() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Project Span',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            smartTextField(
                title: 'Start Date',
                readOnly: true,
                controller: cStartDate,
                onTap: () {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2050),
                  ).then((value) {
                    if (value != null) {
                      debugPrint(
                          "DT: ${value.day}, ${value.month}, ${value.year}");
                      cStartDate.text =
                          "${value.day}-${value.month}-${value.year}";
                    }
                  });
                }),
            smartTextField(
                title: 'End Date',
                readOnly: true,
                controller: cEndDate,
                onTap: () {
                  showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2050))
                      .then((value) {
                    if (value != null) {
                      debugPrint(
                          "DT: ${value.day}, ${value.month}, ${value.year}");
                      cEndDate.text =
                          "${value.day}-${value.month}-${value.year}";
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }

  _workHours() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Work Hours',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            smartTextField(
                title: 'Start Time',
                readOnly: true,
                controller: cStartTime,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      debugPrint("DT: ${value.hour}:${value.minute}");
                      cStartTime.text = "${value.hour}:${value.minute}";
                    }
                  });
                }),
            smartTextField(
                title: 'Close Time',
                readOnly: true,
                controller: cCloseTime,
                onTap: () {
                  showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      debugPrint("DT: ${value.hour}:${value.minute}");
                      cCloseTime.text = "${value.hour}:${value.minute}";
                    }
                  });
                }),
          ],
        ),
      ),
    );
  }

  _focalPerson() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Focal Person',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            smartTextField(
              title: 'Name',
              controller: cFocalName,
            ),
            smartTextField(
                title: 'Email',
                controller: cFocalEmail,
                textInputType: TextInputType.emailAddress),
            smartTextField(
                title: 'Phone No',
                controller: cFocalPhone,
                isPhone: true,
                prefix: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
                  child: Text(
                    '+234',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                textInputType: TextInputType.phone),
            smartTextField(
              title: 'Designation',
              controller: cFocalDesignation,
            ),
          ],
        ),
      ),
    );
  }

  _services() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Services',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ListView.builder(
              shrinkWrap: true,
              itemCount: servicesList.length,
              physics: ClampingScrollPhysics(),
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    servicesList[index].title,
                    style: TextStyle(
                        color: Color(0xFF444444), fontWeight: FontWeight.w600),
                  ),
                  children: <Widget>[
                    _buildExpansionList(servicesList[index].subTitles)
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _details() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Info',
              style: TextStyle(
                color: Colors.white,
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            smartTextField(
              title: 'How to access Services',
              controller: cHow,
            ),
            smartTextField(
              title: 'Criteria to access services',
              controller: cCriteria,
            ),
            smartTextField(
              title: 'Comments',
              controller: cComments,
            ),
          ],
        ),
      ),
    );
  }

  _locations() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Location',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'State',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 18,
              ),
            ),
            DropdownButton(
              isExpanded: true,
              items: _dropDownStateItem,
              value: _currentState,
              onChanged: (MyLocation value) {
                setState(() => _currentState = value);
                _getLocationsFromFirebase(stateId: value.id);
              },
              dropdownColor: Colors.black,
              hint: Text(
                'Select State',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
              elevation: 1,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF444444),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Location',
              style: TextStyle(
                color: Color(0xFF444444),
                fontSize: 18,
              ),
            ),
            DropdownButton(
              isExpanded: true,
              items: _dropDownLocationItem,
              value: _currentLocation,
              onChanged: (MyLocation value) {
                setState(() => _currentLocation = value);
              },
              dropdownColor: Colors.black,
              hint: Text(
                'Select Location',
                style: TextStyle(fontSize: 16, color: Colors.white70),
              ),
              style: TextStyle(fontSize: 16, color: Color(0xFF444444)),
              elevation: 1,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
                color: Color(0xFF444444),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _getDataFromFirebase() async {
    await FirebaseFirestore.instance
        .collection('services')
        .get()
        .then((docs) async {
      for (int i = 0; i < docs.docs.length; i++) {
        List<SubService> tempSubServices = [];
        // debugPrint(
        //     "S ===> ${docs.docs[i].data['title'].toString()}  ::  " +
        //         docs.docs[i].id);
        await FirebaseFirestore.instance
            .collection('services')
            .doc(docs.docs[i].id)
            .collection("sub-services")
            .get()
            .then((subServices) {
          for (int j = 0; j < subServices.docs.length; j++) {
            debugPrint("Sub Services ===> ${subServices.docs[j].get('title')}");
            tempSubServices.add(
              SubService(title: subServices.docs[j].get('title'), value: false),
            );
          }
        });
        servicesList.add(
          Services(
            docs.docs[i].get('title'),
            tempSubServices,
          ),
        );
      }
      setState(() => isLoading = false);
    });
  }

  _getStatesFromFirebase() async {
    await FirebaseFirestore.instance.collection('state').get().then((docs) {
      for (int i = 0; i < docs.docs.length; i++) {
        debugPrint(
            "${docs.docs[i].get('sName').toString()}  ::  " + docs.docs[i].id);
        setState(() => stateList.add(
            MyLocation(docs.docs[i].id.toString(), docs.docs[i].get('sName'))));
      }
      _dropDownStateItem = buildDropDownStateItems(stateList);
    });
  }

  List<DropdownMenuItem<MyLocation>> buildDropDownStateItems(
      List<MyLocation> list) {
    List<DropdownMenuItem<MyLocation>> items = List();
    for (MyLocation location in list) {
      items.add(
        DropdownMenuItem(
          value: location,
          child: Text(location.title),
        ),
      );
    }
    return items;
  }

  _getLocationsFromFirebase({String stateId}) {
    locationsList = [];
    _dropDownLocationItem = [];
    _currentLocation = null;

    FirebaseFirestore.instance
        .collection("state")
        .doc(stateId)
        .collection("locations")
        .get()
        .then((locations) {
      for (int i = 0; i < locations.docs.length; i++) {
        debugPrint(
            "iiiiiii: ${locations.docs[i].get('location').toString()}  ::  " +
                locations.docs[i].id);
        setState(() => locationsList.add(MyLocation(
            locations.docs[i].id.toString(),
            locations.docs[i].get('location'))));
      }
      _dropDownLocationItem = buildDropDownLocationItems(locationsList);
    });
  }

  List<DropdownMenuItem<MyLocation>> buildDropDownLocationItems(
      List<MyLocation> list) {
    List<DropdownMenuItem<MyLocation>> items = [];
    for (MyLocation location in list) {
      items.add(
        DropdownMenuItem(
          value: location,
          child: Text(location.title),
        ),
      );
    }
    return items;
  }

  _buildExpansionList(List<SubService> list) {
    print("********* LIST LENGTH ${list.length} **********");
    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 16.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CheckboxListTile(
          value: list[index].value,
          onChanged: (value) {
            setState(() => list[index].value = value);
            if (value) {
              _selectedServicesList.add(list[index].title);
            } else {
              _selectedServicesList.removeWhere(
                  (element) => element.contains(list[index].title));
            }
          },
          title: Text(
            list[index].title,
            style: TextStyle(color: Color(0xFF444444)),
          ),
        );
      },
    );
  }

  _goBack() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', ModalRoute.withName('/login'));
  }

  void _askOut() {
    askAction(
      actionText: 'Yes',
      cancelText: 'No',
      text: 'Do you want to go back?',
      context: context,
      func: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
      cancelFunc: () => Navigator.pop(context),
    );
  }
}
