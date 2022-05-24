import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/auth_container.dart';
import 'package:smartrr/provider/language_provider.dart';
import '../../widgets/smart_text_field.dart';
import 'select_location_map.dart';
import '../../widgets/circular_progress.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:smartrr/utils/birthDateInput.dart';

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
            'phoneNumber': '${phoneNumberController.text}',
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
    final _language = S.of(context);
    BirthTextInputFormatter birthDateInput = BirthTextInputFormatter();

    return AuthContainer(
        child: isLoading
            ? Center(
                child: CircularProgress(),
              )
            : Consumer<LanguageNotifier>(
                builder: (context, _, child) => SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              height: 22,
                            ),
                            Text(
                              _language.signUp.toUpperCase(),
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
                              title: _language.name,
                              controller: nameController,
                              isForm: true,
                            ),
                            smartTextField(
                              title: 'Email',
                              controller: emailController,
                              isForm: true,
                              textInputType: TextInputType.emailAddress,
                              required: false,
                            ),
                            smartTextField(
                              title: _language.phoneNumber,
                              controller: phoneNumberController,
                              isForm: true,
                              isPhone: true,
                              textInputType: TextInputType.phone,
                              required: false,
                            ),
                            smartTextField(
                              title: _language.password,
                              controller: passwordController,
                              isForm: true,
                              obscure: true,
                            ),
                            smartTextField(
                              title: _language.dob,
                              controller: dobController,
                              isForm: true,
                              validator: birthDateValidator,
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(10),
                                FilteringTextInputFormatter.singleLineFormatter,
                                birthDateInput,
                              ],
                              textInputType: TextInputType.phone,
                            ),
                            smartTextField(
                              title: _language.location,
                              readOnly: true,
                              isForm: true,
                              controller: locationController,
                              onTap: () async {
                                String selectedAddress = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            SelectLocationMap()));
                                setState(() {
                                  if (selectedAddress != null)
                                    locationController.text =
                                        '$selectedAddress';
                                });
                              },
                            ),
                            Text(
                              _language.gender,
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
                                          print('===> $val');
                                          if (val)
                                            setState(() => _isMale = false);
                                          else
                                            setState(() => _isMale = true);
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
                              height: 47,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextButton(
                                    onPressed: _validateRegisterInput,
                                    child: Text(
                                      _language.signUp,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    "${_language.alreadyHaveAnAccount} ",
                                    style: TextStyle(),
                                  ),
                                  Text(
                                    _language.logIn,
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
                    )));
  }
}
