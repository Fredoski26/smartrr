import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/auth_container.dart';
import 'package:smartrr/generated/l10n.dart';

class LoginPage extends StatefulWidget {
  final bool isDarkTheme;

  LoginPage({this.isDarkTheme});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final mScaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController emailController;
  TextEditingController passwordController;
  String errorMsg;
  bool _isUser = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
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
                            "login smart rr".toUpperCase(),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          smartTextField(
                            title: 'Email',
                            controller: emailController,
                            isForm: true,
                            textInputType: TextInputType.emailAddress,
                          ),
                          smartTextField(
                              title: 'Password',
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
                                      S.of(context).user,
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
                                      S.of(context).organization,
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
                                  child: Text("Login"),
                                ),
                              ),
                            ],
                          ),
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
                                  S.of(context).dontHaveAccount,
                                  style: TextStyle(
                                    fontSize: 12.0,
                                  ),
                                ),
                                Text(
                                  S.of(context).signUp,
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
                                  S.of(context).forgotPassword,
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
            color: isDarkTheme ? darkGrey : Colors.white,
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
            debugPrint(
                "USR ===> ${users.docs[0].get('displayName').toString()}  ::  Gender: ${users.docs[0].get('gender')} : ${users.docs[0].id}");
            bool status = users.docs[0].get('status');
            switch (status) {
              // Approved
              case true:
                _loginUser(userId: users.docs[0].id.toString());
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
            // debugPrint(
            //     "ORG ===> ${orgs.docs[0].data['name'].toString()}  ::  Status: ${orgs.docs[0].data['status']}");
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
                _loginOrg(orgId: orgs.docs[0].id.toString());
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

  _loginUser({String userId}) {
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
            setUserIdPref(userId: userId).then((_) =>
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

  _loginOrg({String orgId}) {
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
}
