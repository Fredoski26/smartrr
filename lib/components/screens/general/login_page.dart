import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smartrr/components/auth_wrapper.dart';
import 'package:smartrr/components/screens/main_wrapper.dart';
import 'package:smartrr/components/screens/user/otp.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/show_loading.dart';
import 'package:smartrr/components/widgets/smart_input.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/auth_service.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/emailValidator.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LoginPage extends StatefulWidget {
  LoginPage();
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  final mScaffoldState = GlobalKey<ScaffoldState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController phoneNumberController;
  late String errorMsg;
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
        builder: (context, LanguageNotifier notifier, child) => Scaffold(
              appBar: AppBar(actions: [LanguagePicker()]),
              body: Form(
                key: _formKey,
                child: isLoading
                    ? Center(
                        child: CircularProgress(),
                      )
                    : ListView(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        children: <Widget>[
                            SizedBox(
                              height: 74,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "${_language.logIn}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
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
                              onTap: () => _bottomSheet(context: context),
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
                                      color: primaryColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                          ]),
              ),
            ));
  }

  Widget _emailSignInWidgets() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Text(
              "Use phone number instead",
              style: TextStyle().copyWith(
                color: primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: _toggleSignInMode,
          ),
        ),
        SmartInput(
          controller: emailController,
          label: "Email",
          keyboardType: TextInputType.emailAddress,
          isRequired: true,
          validator: (email) {
            if (!EmailValidator.isValidEmail(email)) {
              return "Invalid email";
            }
            return null;
          },
        ),
        SmartInput(
          controller: passwordController,
          label: S.current.password,
          obscureText: true,
          isRequired: true,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/forgot'),
            child: Text(
              "${S.current.forgotPassword} ",
              style: TextStyle(
                fontSize: 12.0,
                color: primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
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
                      setState(() => _isUser = val!);
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
                      if (val!)
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
      ],
    );
  }

  Widget _phoneSignInWidgets() {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Text(
              "Use email instead",
              style: TextStyle().copyWith(
                color: primaryColor,
                decoration: TextDecoration.underline,
              ),
            ),
            onTap: _toggleSignInMode,
          ),
        ),
        SizedBox(height: 14),
        Align(alignment: Alignment.centerLeft, child: Text("Mobile Number")),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 6),
          margin: EdgeInsets.only(bottom: 15.0, top: 6),
          decoration: BoxDecoration(
            color: inputBackground,
            borderRadius: BorderRadius.all(Radius.circular(6.0)),
          ),
          child: InternationalPhoneNumberInput(
            textStyle: TextStyle().copyWith(color: darkGrey),
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
            hintText: "",
          ),
        ),
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: _loginWithPhone,
                child: Text(S.current.requestOTP),
              ),
            ),
          ],
        ),
      ],
    );
  }

  _bottomSheet({required BuildContext context}) {
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
    final FormState form = _formKey.currentState!;
    if (_formKey.currentState!.validate()) {
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
    if (_formKey.currentState!.validate()) {
      setState(() => isLoading = true);

      if (await _userExists(number.phoneNumber!)) {
        int? _resetToken;

        await _auth
            .verifyPhoneNumber(
          phoneNumber: number.phoneNumber,
          verificationCompleted: _onVerificationCompleted,
          verificationFailed: _handlePhoneAuthError,
          forceResendingToken: _resetToken,
          codeAutoRetrievalTimeout: (String verificationId) {},
          codeSent: (String verificationId, int? resendToken) {
            setState(() => isLoading = false);
            _resetToken = resendToken;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OTPScreen(verificationId: verificationId),
              ),
            );
          },
        )
            .onError((error, stackTrace) async {
          Navigator.pop(context);
          showToast(msg: error.toString(), type: "error");
          await Sentry.captureException(error, stackTrace: stackTrace);
        });
      } else {
        setState(() {
          errorMsg = "Account does not exist";
          isLoading = false;
        });
        _showException();
      }
    }
  }

  _onVerificationCompleted(PhoneAuthCredential credential) async {
    await AuthService.handleSignInWithPhone(
      credential: credential,
      context: context,
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainWrapper(),
      ),
      ModalRoute.withName("/userMain"),
    );
  }

  _handlePhoneAuthError(dynamic error) {
    Navigator.pop(context);
    setState(() => isLoading = false);
    switch (error.code) {
      case 'invalid-phone-number':
        return showToast(
            msg: 'The provided phone number is not valid', type: "error");
      case "invalid-verification-code":
        return showToast(msg: 'Invalid verification code', type: "error");
      default:
        showToast(msg: error.message!, type: "error");
        break;
    }
  }

  Future<bool> _userExists(String phoneNumber) async {
    final user = await FirebaseFirestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .get();

    if (!user.docs.isEmpty) return true;
    return false;
  }

  _loginUser({required String userId, required String userDocId}) async {
    bool _isLoginError = false;
    try {
      return await FirebaseAuth.instance
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
        (UserCredential result) async {
          if (!_isLoginError) {
            await setUserIdPref(userId: userId, userDocId: userDocId);
            await onLoginSuccessful(result.user!);
            setState(() => isLoading = false);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => AuthWrapper(),
              ),
              ModalRoute.withName("/"),
            );
          }
        },
      );
    } catch (error, stackTrace) {
      setState(() {
        errorMsg = "An error occured!";
        isLoading = false;
      });
      _showException();
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  _loginOrg({required String orgId}) async {
    bool _isLoginError = false;
    try {
      return await FirebaseAuth.instance
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
        (UserCredential result) async {
          if (!_isLoginError) {
            await setOrgIdPref(orgId: orgId);
            await onLoginSuccessful(result.user!);
            setState(() => isLoading = false);
            Navigator.pushNamedAndRemoveUntil(
              context,
              '/orgMain',
              ModalRoute.withName('Dashboard'),
            );
          }
        },
      );
    } catch (error, stackTrace) {
      setState(() {
        errorMsg = "User not found!";
        isLoading = false;
      });
      _showException();
      await Sentry.captureException(error, stackTrace: stackTrace);
    }
  }

  Future onLoginSuccessful(User user) async {
    await DatabaseService().setDeviceToken(user);
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
