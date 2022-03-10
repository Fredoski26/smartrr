import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/utils/utils.dart';

class LoginPage extends StatefulWidget {
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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: mScaffoldState,
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(children: [
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
                                    'LOGIN SMART RR',
                                    style: TextStyle(
                                      color: Color(0xFF444444),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
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
                                              'User',
                                              style: TextStyle(
                                                  color: Color(0xFF444444)),
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
                                                print('===> $val');
                                                if (val)
                                                  setState(
                                                      () => _isUser = false);
                                                else
                                                  setState(
                                                      () => _isUser = true);
                                              },
                                            ),
                                            Text(
                                              'Organization',
                                              style: TextStyle(
                                                  color: Color(0xFF444444)),
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
                                    onTap: () => _bottomSheet(context: context),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          "Don't have an account?",
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Color(0xFF444444),
                                          ),
                                        ),
                                        Text(
                                          ' SignUp',
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            fontSize: 12.0,
                                            color: Color(0xFF444444),
                                          ),
                                        ),
                                        Text(' Reset Here',
                                            style: TextStyle(
                                              color: Color(0xFFF59405),
                                              fontWeight: FontWeight.w600,
                                            ))
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 20),
                                ]),
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
          )
        ]),
      ),
    );
  }

  _bottomSheet({BuildContext context}) {
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10),
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Card(
                  elevation: 2,
                  shadowColor: Colors.purple,
                  child: ListTile(
                    title: Text('User'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/userSignup');
                    },
                  ),
                ),
                Card(
                  elevation: 2,
                  shadowColor: Colors.purple,
                  child: ListTile(
                    title: Text('Organization'),
                    trailing: Icon(Icons.keyboard_arrow_right),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/orgSignup');
                    },
                  ),
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
            // int status = orgs.docs[0].data['status'];
            // switch (status) {
            //   // Awaiting
            //   case 0:
            //     setState(() {
            //       errorMsg = "Waiting for Approval!";
            //       isLoading = false;
            //     });
            //     _showException();
            //     break;
            //   // Approved
            //   case 1:
            //     _loginOrg(orgId: orgs.docs[0].id.toString());
            //     break;
            // // DisApproved
            //   case 2:
            //     setState(() {
            //       errorMsg = "Account Disapproved!";
            //       isLoading = false;
            //     });
            //     _showException();
            //     break;
            //   default:
            //     setState(() {
            //       errorMsg = "An error occured!";
            //       isLoading = false;
            //     });
            //     _showException();
            //     break;
            // }
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
