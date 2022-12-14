import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:smartrr/components/widgets/auth_container.dart';
import 'package:smartrr/models/country.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/services/country_service.dart';
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
  int _maxSteps = 4;

  late GlobalKey<FormState> _formKey;
  late TextEditingController cName;
  late TextEditingController cTelephone;
  late TextEditingController cOrgEmail;
  late TextEditingController cPassword;
  late TextEditingController cLanguage;
  late TextEditingController cStartTime;
  late TextEditingController cCloseTime;
  late TextEditingController cFocalName;
  late TextEditingController cFocalEmail;
  late TextEditingController cFocalPhone;
  late TextEditingController cFocalDesignation;
  late TextEditingController phoneNumberController;

  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  PhoneNumber focalNumber = PhoneNumber(isoCode: "NG");

  late String errorMsg;
  double _hPadding = 18.0;
  bool isLoading = false;
  List<Services> servicesList = <Services>[];
  List<String> _selectedServicesList = [];

  // States
  List<MyLocation> stateList = <MyLocation>[];
  List<DropdownMenuItem<MyLocation>> _dropDownStateItem = [];
  late MyLocation _currentState;

  // Locations
  List<MyLocation> locationsList = <MyLocation>[];
  List<DropdownMenuItem<MyLocation>> _dropDownLocationItem = [];
  late MyLocation _currentLocation;

  // Country
  List<Country> countriesList = <Country>[];
  List<DropdownMenuItem<Country>> _dropDownCountryItem = [];
  late Country _currentCountry;

  // organization types
  List<DropdownMenuItem> _orgTypes = [
    DropdownMenuItem(child: Text("NGO"), value: "NGO"),
    DropdownMenuItem(child: Text("CSO"), value: "CSO"),
    DropdownMenuItem(child: Text("MDA"), value: "MDA"),
    DropdownMenuItem(child: Text("FBO"), value: "FBO"),
    DropdownMenuItem(child: Text("CBO"), value: "CBO")
  ];
  String _orgType = "NGO";
  String _orgTypeLabel = "Type of Organization";

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    cName = TextEditingController();
    cTelephone = TextEditingController();
    cOrgEmail = TextEditingController();
    cPassword = TextEditingController();
    cLanguage = TextEditingController();
    cStartTime = TextEditingController();
    cCloseTime = TextEditingController();
    cFocalName = TextEditingController();
    cFocalEmail = TextEditingController();
    cFocalPhone = TextEditingController();
    cFocalDesignation = TextEditingController();
    phoneNumberController = TextEditingController();

    _getDataFromFirebase();
    _getCountries();
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
          body: AuthContainer(
            isOrgSignUp: true,
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 500),
                transitionBuilder:
                    (Widget child, Animation<double> animation) =>
                        ScaleTransition(child: child, scale: animation),
                child: IndexedStack(
                  key: ValueKey<int>(_stepIndex),
                  index: _stepIndex,
                  children: [
                    _stack1(),
                    _workHours(),
                    _focalPerson(),
                    _services(),
                    _locations(),
                  ],
                )),
          )),
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
      authResult.user!.updateDisplayName(displayName).then((onValue) async {
        await FirebaseFirestore.instance
            .collection('organizations')
            .doc(authResult.user!.uid)
            .set({
          'name': cName.text,
          'type': _orgType,
          'telephone': number.phoneNumber,
          'orgEmail': cOrgEmail.text,
          'password': cPassword.text,
          'language': cLanguage.text,
          'startTime': cStartTime.text,
          'closeTime': cCloseTime.text,
          'focalName': cFocalName.text,
          'focalEmail': cFocalEmail.text,
          'focalPhone': focalNumber.phoneNumber,
          'focalDesignation': cFocalDesignation.text,
          'servicesAvailable': FieldValue.arrayUnion(_selectedServicesList),
          'status': 0,
          'locationId': null,
          'state': _currentState.title,
          'location': _currentLocation.title,
          'uId': authResult.user!.uid,
          'country': _currentCountry.name
        }).then((onValue) {
          FirebaseAuth.instance.signOut();
          Navigator.pop(context);
          showAction(
            actionText: 'OK',
            text: "You'll get Approval Email Soon",
            func: _goBack,
            context: context,
          );
        });
      });
    } catch (error) {
      Navigator.pop(context);
      switch ((error as FirebaseAuthException).code) {
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
        final FormState form = _formKey.currentState!;
        if (_formKey.currentState!.validate()) {
          form.save();
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
          setState(() => _stepIndex++);
        }
      } else {
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
              SizedBox(
                height: 20,
              ),
              Text(
                'REGISTER',
                style: TextStyle(
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
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButtonFormField(
                          decoration: InputDecoration().copyWith(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 25.0, vertical: 6.0),
                            enabledBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(color: lightGrey)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(color: lightGrey)),
                            errorBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50)),
                                borderSide: BorderSide(color: Colors.red)),
                          ),
                          hint: Text(
                            _orgTypeLabel,
                            style: Theme.of(context)
                                .inputDecorationTheme
                                .hintStyle,
                          ),
                          elevation: 0,
                          items: _orgTypes,
                          validator: (dynamic val) =>
                              val == null ? "Select org type" : null,
                          onChanged: (dynamic val) {
                            setState(() {
                              _orgType = val;
                            });
                          }),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.0),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(width: 1, color: lightGrey)),
                child: InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber val) {
                    number = val;
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  selectorTextStyle:
                      Theme.of(context).inputDecorationTheme.hintStyle,
                  initialValue: number,
                  textFieldController: phoneNumberController,
                  inputBorder: InputBorder.none,
                  selectorButtonOnErrorPadding: 0,
                  spaceBetweenSelectorAndTextField: 0,
                ),
              ),
              SizedBox(height: 20.0),
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
            ],
          ),
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
            Container(
              padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  border: Border.all(width: 1, color: lightGrey)),
              child: InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber val) {
                  number = val;
                },
                ignoreBlank: true,
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                ),
                selectorTextStyle:
                    Theme.of(context).inputDecorationTheme.hintStyle,
                initialValue: focalNumber,
                textFieldController: cFocalPhone,
                inputBorder: InputBorder.none,
                selectorButtonOnErrorPadding: 0,
                spaceBetweenSelectorAndTextField: 0,
              ),
            ),
            SizedBox(height: 20),
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
                    style: TextStyle(fontWeight: FontWeight.w600),
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

  _locations() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: _hPadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Location',
              textAlign: TextAlign.center,
              style: TextStyle()
                  .copyWith(fontSize: 40, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Country',
              style: TextStyle().copyWith(fontSize: 18),
            ),
            DropdownButton(
              isExpanded: true,
              items: _dropDownCountryItem,
              value: _currentCountry,
              onChanged: (Country? value) {
                setState(() => _currentCountry = value!);
                _getStates();
              },
              hint: Text(
                'Select Country',
                style: TextStyle().copyWith(fontSize: 16),
              ),
              elevation: 1,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
            ),
            Text(
              'State',
              style: TextStyle().copyWith(fontSize: 18),
            ),
            DropdownButton(
              isExpanded: true,
              items: _dropDownStateItem,
              value: _currentState,
              onChanged: (MyLocation? value) {
                setState(() => _currentState = value!);
                _getLocations(state: value!.title);
              },
              hint: Text(
                'Select State',
                style: TextStyle().copyWith(fontSize: 16),
              ),
              elevation: 1,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Location',
              style: TextStyle().copyWith(fontSize: 18),
            ),
            DropdownButton(
              isExpanded: true,
              items: _dropDownLocationItem,
              value: _currentLocation,
              onChanged: (MyLocation? location) async {
                setState(() => _currentLocation = location!);
              },
              hint: Text(
                'Select Location',
                style: TextStyle().copyWith(fontSize: 16),
              ),
              elevation: 1,
              underline: SizedBox(),
              icon: Icon(
                Icons.keyboard_arrow_down,
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
        await FirebaseFirestore.instance
            .collection('services')
            .doc(docs.docs[i].id)
            .collection("sub-services")
            .get()
            .then((subServices) {
          for (int j = 0; j < subServices.docs.length; j++) {
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
      if (mounted) setState(() => isLoading = false);
    });
  }

  _getStates() async {
    await CountryService.getStates(_currentCountry.name).then((states) {
      List<MyLocation> items = [];
      for (int i = 0; i < states.length; i++) {
        if (states[i]["name"] == "Federal Capital Territory") {
          items.add(MyLocation("Abuja", "Abuja"));
        } else {
          items.add(MyLocation(states[i]["name"], states[i]["name"]));
        }
      }
      setState(() {
        stateList = items;
        _dropDownStateItem = buildDropDownStateItems(items);
      });
      ;
    });
  }

  List<DropdownMenuItem<MyLocation>> buildDropDownStateItems(
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

  _getCountries() async {
    await CountryService.getCountries().then((countries) {
      setState(() {
        countriesList = countries;
      });
    });
    for (Country country in countriesList) {
      _dropDownCountryItem.add(DropdownMenuItem(
        child: Text(country.name),
        value: country,
      ));
    }
  }

  Future _getLocations({String? state}) async {
    locationsList = [];
    _dropDownLocationItem = [];
    CountryService.getCities(_currentCountry.name, state!).then((locations) {
      List<MyLocation> items = [];
      for (int i = 0; i < locations.length; i++) {
        items.add(MyLocation(locations[i], locations[i]));
      }
      setState(() {
        locationsList = items;
        _dropDownLocationItem = buildDropDownLocationItems(locationsList);
      });
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
    return ListView.builder(
      itemCount: list.length,
      padding: const EdgeInsets.only(bottom: 16.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return CheckboxListTile(
          value: list[index].value,
          onChanged: (value) {
            setState(() => list[index].value = value!);
            if (value!) {
              _selectedServicesList.add(list[index].title);
            } else {
              _selectedServicesList.removeWhere(
                  (element) => element.contains(list[index].title));
            }
          },
          title: Text(
            list[index].title,
            style: TextStyle(),
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

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
