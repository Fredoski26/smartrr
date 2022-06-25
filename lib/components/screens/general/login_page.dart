import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/auth_container.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  final bool isDarkTheme;

  LoginPage({this.isDarkTheme});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final mScaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController emailController;
  TextEditingController passwordController;
  TextEditingController phoneNumberController;
  String errorMsg;
  bool _isUser = true;
  bool isLoading = false;

  ValueNotifier<bool> _signInWithPhone = ValueNotifier<bool>(true);

  void _toggleSignInMode() {
    _signInWithPhone.value = !_signInWithPhone.value;
  }

  String initialCountry = 'NG';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    phoneNumberController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
        builder: (context, LanguageNotifier notifier, child) => AuthContainer(
                child: Form(
              key: _formKey,
              child: isLoading
                  ? Center(
                      child: CircularProgress(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                          SizedBox(
                            height: kToolbarHeight,
                          ),
                          Text(
                            "${_language.logIn} smart rr".toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          ValueListenableBuilder(
                              valueListenable: _signInWithPhone,
                              builder: (context, _, __) {
                                if (_signInWithPhone.value)
                                  return _phoneSignInWidgets();
                                return _emailSignInWidgets();
                              }),
                          SizedBox(height: 38.0),
                          GestureDetector(
                            onTap: () => _bottomSheet(
                                context: context,
                                isDarkTheme: widget.isDarkTheme),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  "${_language.dontHaveAccount} ",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  _language.signUp,
                                  style: TextStyle(
                                    color: Color(0xFFF59405),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 21),
                          GestureDetector(
                            onTap: () =>
                                Navigator.pushNamed(context, '/forgot'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${_language.forgotPassword} ",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(S.of(context).resetHere,
                                    style: TextStyle(
                                      color: Color(0xFFF59405),
                                      fontWeight: FontWeight.w600,
                                    ))
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                        ]),
            )));
  }

  Widget _emailSignInWidgets() {
    return Column(
      children: [
        smartTextField(
          title: 'Email',
          controller: emailController,
          isForm: true,
          textInputType: TextInputType.emailAddress,
        ),
        smartTextField(
            title: S.current.password,
            controller: passwordController,
            obscure: true,
            isForm: true,
            suffixIcon: Icon(Icons.e_mobiledata)),
        SizedBox(
          height: 5,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                if (_isUser)
                  setState(() => _isUser = false);
                else
                  setState(() => _isUser = true);
              },
              child: Row(
                children: [
                  Checkbox(
                    value: _isUser,
                    onChanged: (val) {
                      setState(() => _isUser = val);
                    },
                  ),
                  Text(
                    S.current.user,
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                if (_isUser)
                  setState(() => _isUser = false);
                else
                  setState(() => _isUser = true);
              },
              child: Row(
                children: [
                  Checkbox(
                    value: !_isUser,
                    onChanged: (val) {
                      if (val)
                        setState(() => _isUser = false);
                      else
                        setState(() => _isUser = true);
                    },
                  ),
                  Text(
                    S.current.organization,
                  ),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _validateLoginInput,
                child: Text(S.current.logIn),
              ),
            ),
          ],
        ),
        InkWell(
          child: Text(
            "Sign in with phone",
            style: TextStyle().copyWith(color: primaryColor),
          ),
          onTap: _toggleSignInMode,
        ),
      ],
    );
  }

  Widget _phoneSignInWidgets() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 0),
          margin: EdgeInsets.only(bottom: 15.0),
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
            selectorTextStyle: Theme.of(context).inputDecorationTheme.hintStyle,
            initialValue: number,
            textFieldController: phoneNumberController,
            inputBorder: InputBorder.none,
            selectorButtonOnErrorPadding: 0,
            spaceBetweenSelectorAndTextField: 0,
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _loginWithPhone,
                child: Text(S.current.logIn),
              ),
            ),
          ],
        ),
        InkWell(
          child: Text(
            "Sign in with email",
            style: TextStyle().copyWith(color: primaryColor),
          ),
          onTap: _toggleSignInMode,
        ),
      ],
    );
  }

  _bottomSheet({BuildContext context, bool isDarkTheme}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 10),
                Text(
                  S.of(context).signUp,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/userSignup');
                  },
                  child: Text(S.of(context).user),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, '/orgSignup');
                  },
                  child: Text(S.of(context).organization),
                ),
              ],
            ),
          );
        });
  }

  void _validateLoginInput() async {
    final FormState form = _formKey.currentState;
    if (_formKey.currentState.validate()) {
      form.save();
      setState(() => isLoading = true);
      if (_isUser) {
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .where('email', isEqualTo: emailController.text)
              .get()
              .then((users) {
            bool status = users.docs[0].get('status');
            switch (status) {
              // Approved
              case true:
                _loginUser(
                    userId: users.docs[0].get("uId"),
                    userDocId: users.docs[0].id);
                break;
              // DisApproved
              case false:
                setState(() {
                  errorMsg = "Account Blocked!";
                  isLoading = false;
                });
                _showException();
                break;
              default:
                setState(() {
                  errorMsg = "An error occured!";
                  isLoading = false;
                });
                _showException();
                break;
            }
          });
        } catch (error) {
          setState(() {
            errorMsg = "User not found!";
            isLoading = false;
          });
          _showException();
        }
      } else {
        try {
          await FirebaseFirestore.instance
              .collection('organizations')
              .where('orgEmail', isEqualTo: emailController.text)
              .get()
              .then((orgs) {
            int status = orgs.docs[0].get('status');
            switch (status) {
              // Awaiting
              case 0:
                setState(() {
                  errorMsg = "Waiting for Approval!";
                  isLoading = false;
                });
                _showException();
                break;
              // Approved
              case 1:
                _loginOrg(orgId: orgs.docs[0].id);
                break;
              // DisApproved
              case 2:
                setState(() {
                  errorMsg = "Account Disapproved!";
                  isLoading = false;
                });
                _showException();
                break;
              default:
                setState(() {
                  errorMsg = "An error occured!";
                  isLoading = false;
                });
                _showException();
                break;
            }
          });
        } catch (error) {
          setState(() {
            errorMsg = "An error occured!";
            isLoading = false;
          });
          _showException();
        }
      }
    }
  }

  void _loginWithPhone() async {
    if (_formKey.currentState.validate()) {
      setState(() => isLoading = true);

      if (await _userExists(number.phoneNumber)) {
        await _auth.verifyPhoneNumber(
          phoneNumber: number.phoneNumber,
          verificationCompleted: (PhoneAuthCredential credential) async {
            await _handleSignInWithPhone(
                credential: credential, context: context);
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() => isLoading = false);
            switch (e.code) {
              case 'invalid-phone-number':
                showToast(
                    msg: 'The provided phone number is not valid',
                    type: "error");
                break;
              default:
                showToast(msg: e.message, type: "error");
                break;
            }
          },
          codeSent: (String verificationId, int resendToken) async {
            setState(() => isLoading = false);
            final formKey = GlobalKey<FormState>();
            final pinController = TextEditingController();

            showDialog(
              context: context,
              builder: (context) => Dialog(
                child: Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Verification Code",
                                  style: TextStyle().copyWith(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Enter the verification code sent to your mobile phone",
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 5.0),
                            Form(
                                key: formKey,
                                child: Pinput(
                                    length: 6,
                                    controller: pinController,
                                    onSubmitted: (pin) async {
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode: pin);

                                      await _handleSignInWithPhone(
                                          context: context,
                                          credential: credential);
                                    },
                                    validator: (pin) =>
                                        pin.length < 6 || pin.length > 6
                                            ? "Invalid code"
                                            : null)),
                            SizedBox(height: 5.0),
                            ElevatedButton(
                                onPressed: () async {
                                  if (formKey.currentState.validate()) {
                                    setState(() => isLoading = true);
                                    try {
                                      PhoneAuthCredential credential =
                                          PhoneAuthProvider.credential(
                                              verificationId: verificationId,
                                              smsCode: pinController.text);

                                      await _handleSignInWithPhone(
                                          context: context,
                                          credential: credential);
                                    } catch (e) {
                                      showToast(
                                          msg: e.toString(), type: "error");
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Text("Continue"))
                          ],
                        ),
                ),
              ),
            );
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } else {
        setState(() {
          errorMsg = "Account does not exist";
          isLoading = false;
        });
        _showException();
      }
    }
  }

  _handleSignInWithPhone(
      {PhoneAuthCredential credential, BuildContext context}) async {
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final users = await FirebaseFirestore.instance
        .collection("users")
        .where("uId", isEqualTo: userCredential.user.uid)
        .get();

    await setUserIdPref(
        userId: userCredential.user.uid, userDocId: users.docs[0].id);

    Navigator.pushNamedAndRemoveUntil(
        context, '/userMain', ModalRoute.withName('Dashboard'));
  }

  Future<bool> _userExists(String phoneNumber) async {
    final user = await FirebaseFirestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();

    if (!user.docs.isEmpty) return true;
    return false;
  }

  _loginUser({String userId, String userDocId}) {
    bool _isLoginError = false;
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .catchError((error) {
        setState(() {
          errorMsg = "Check your Email & Password";
          isLoading = false;
        });
        setState(() => _isLoginError = true);
        _showException();
      }).then(
        (UserCredential result) {
          setState(() => isLoading = false);
          if (!_isLoginError) {
            setUserIdPref(userId: userId, userDocId: userDocId).then((_) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/userMain', ModalRoute.withName('Dashboard')));
          }
        },
      );
    } catch (error) {
      setState(() {
        errorMsg = "An error occured!";
        isLoading = false;
      });
      _showException();
    }
  }

  _loginOrg({@required String orgId}) {
    bool _isLoginError = false;
    try {
      FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: passwordController.text)
          .catchError((error) {
        setState(() {
          errorMsg = "Check your Email & Password";
          isLoading = false;
        });
        setState(() => _isLoginError = true);
        _showException();
      }).then(
        (UserCredential result) {
          setState(() => isLoading = false);
          if (!_isLoginError) {
            setOrgIdPref(orgId: orgId).then((_) =>
                Navigator.pushNamedAndRemoveUntil(
                    context, '/orgMain', ModalRoute.withName('Dashboard')));
          }
        },
      );
    } catch (error) {
      setState(() {
        errorMsg = "User not found!";
        isLoading = false;
      });
      _showException();
    }
  }

  void _showException() {
    showAction(
      actionText: 'OK',
      text: errorMsg,
      func: () => Navigator.pop(context),
      context: context,
    );
  }

  @override
  void dispose() {
    phoneNumberController.dispose();
    super.dispose();
  }
}
