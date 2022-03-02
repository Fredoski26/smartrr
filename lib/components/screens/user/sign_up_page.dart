import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../widgets/smart_text_field.dart';
import 'select_location_map.dart';
import '../../widgets/circular_progress.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController;
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneNumberController;
  TextEditingController dobController;
  TextEditingController locationController;
  TextEditingController ageController;
  TextEditingController cnicController;
  String errorMsg;
  bool _isMale = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
    dobController = TextEditingController();
    locationController = TextEditingController();
    cnicController = TextEditingController();
  }

  void _validateRegisterInput() async {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      form.save();
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential authResult = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: emailController.text, password: passwordController.text);
        var displayName;
        displayName = nameController.text;

        await authResult.user.updateDisplayName(displayName).then((onValue) {
          int maleOrFemale = 1;
          if (!_isMale) maleOrFemale = 0;
          FirebaseFirestore.instance.collection('users').doc().set({
            'email': emailController.text,
            'displayName': nameController.text,
            'phoneNumber': '234${phoneNumberController.text}',
            'cnic': cnicController.text.toString(),
            'location': locationController.text,
            'dob': dobController.text,
            'gender': maleOrFemale,
            'status': true,
            'uId': authResult.user.uid,
          }).then((onValue) {
            Fluttertoast.showToast(
              msg: "Please Login",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.black54.withOpacity(0.3),
              textColor: Colors.white,
              fontSize: 16.0,
            ).then((_) => Navigator.pop(context));
            setState(() {
              isLoading = false;
            });
          });
        });
      } catch (error) {
        switch (error.code) {
          case "ERROR_EMAIL_ALREADY_IN_USE":
            {
              setState(() {
                errorMsg = "This email is already in use.";
                isLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
                    );
                  });
            }
            break;
          case "ERROR_WEAK_PASSWORD":
            {
              setState(() {
                errorMsg = "The password must be 6 characters long or more.";
                isLoading = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Container(
                        child: Text(errorMsg),
                      ),
                    );
                  });
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              Positioned(
                top: -135,
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
                        margin: EdgeInsets.only(top: 123),
                        padding: EdgeInsets.all(30),
                        width: 318,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(22),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF444444).withOpacity(0.5),
                              offset: Offset(0, 4),
                              blurRadius: 122,
                            )
                          ],
                        ),
                        child: isLoading
                            ? Center(
                                child: CircularProgress(),
                              )
                            : SingleChildScrollView(
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: <Widget>[
                                      SizedBox(
                                        height: 22,
                                      ),
                                      Text(
                                        'Register'.toUpperCase(),
                                        style: TextStyle(
                                          color: Color(0xFF444444),
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 47,
                                      ),
                                      smartTextField(
                                        title: 'Name',
                                        controller: nameController,
                                        isForm: true,
                                      ),
                                      smartTextField(
                                        title: 'Email',
                                        controller: emailController,
                                        isForm: true,
                                        textInputType:
                                            TextInputType.emailAddress,
                                      ),
                                      smartTextField(
                                        title: 'Password',
                                        controller: passwordController,
                                        isForm: true,
                                        obscure: true,
                                      ),
                                      smartTextField(
                                        title: 'DOB',
                                        readOnly: true,
                                        isForm: true,
                                        controller: dobController,
                                        onTap: () {
                                          debugPrint("DT tapped");
                                          showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime.now())
                                              .then(
                                            (value) {
                                              if (value != null) {
                                                debugPrint(
                                                    "DT: ${value.day}, ${value.month}, ${value.year}");
                                                dobController.text =
                                                    "${value.day}-${value.month}-${value.year}";
                                              }
                                            },
                                          );
                                        },
                                      ),
                                      smartTextField(
                                        title: 'Location',
                                        readOnly: true,
                                        isForm: true,
                                        controller: locationController,
                                        onTap: () async {
                                          print('Location selected pressed');
                                          String selectedAddress =
                                              await Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (BuildContext
                                                              context) =>
                                                          SelectLocationMap()));
                                          setState(() {
                                            if (selectedAddress != null)
                                              locationController.text =
                                                  '$selectedAddress';
                                          });
                                        },
                                      ),
                                      smartTextField(
                                          title: 'Phone No.',
                                          controller: phoneNumberController,
                                          isForm: true,
                                          isPhone: true,
                                          prefix: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 14, horizontal: 4),
                                            child: Text(
                                              '+234',
                                              style: TextStyle(
                                                color: Color(0xFFA59B9B),
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          textInputType: TextInputType.phone),
                                      smartTextField(
                                        title: 'National ID Card No.',
                                        controller: cnicController,
                                        isForm: false,
                                        required: false,
                                        textInputType: TextInputType.number,
                                      ),
                                      Text(
                                        'Gender',
                                        style: TextStyle(
                                          color: Color(0xFF444444),
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
                                                    print('===> $val');
                                                    if (val)
                                                      setState(
                                                          () => _isMale = true);
                                                    else
                                                      setState(() =>
                                                          _isMale = false);
                                                  },
                                                ),
                                                Text(
                                                  'Male',
                                                  style: TextStyle(
                                                      color: Color(0xFF444444)),
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
                                                      setState(() =>
                                                          _isMale = false);
                                                    else
                                                      setState(
                                                          () => _isMale = true);
                                                  },
                                                ),
                                                Text(
                                                  'Female',
                                                  style: TextStyle(
                                                      color: Color(0xFF444444)),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 47,
                                      ),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: TextButton(
                                              onPressed: _validateRegisterInput,
                                              child: Text(
                                                'Sign Up',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 17,
                                      ),
                                      GestureDetector(
                                        onTap: () => Navigator.pop(context),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Already have an account?",
                                              style: TextStyle(
                                                color: Color(0xFF494949),
                                              ),
                                            ),
                                            Text(
                                              ' Login',
                                              style: TextStyle(
                                                  color: Color(0xFFFD9A05),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 109.0,
                        width: 109.0,
                        margin: EdgeInsets.only(top: 63.0),
                        child: Image.asset("assets/logo.png"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )),
    );
  }
}
