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
        padding: EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: _formKey,
          child: isLoading
              ? Center(
                  child: CircularProgress(),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                      SizedBox(
                        height: kToolbarHeight,
                      ),
                      Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
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
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () => Navigator.pushNamed(context, '/forgot'),
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
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
                                    print('===> $val');
                                    if (val)
                                      setState(() => _isUser = true);
                                    else
                                      setState(() => _isUser = false);
                                  },
                                ),
                                Text(
                                  'User',
                                  style: TextStyle(color: Colors.white),
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
                                      setState(() => _isUser = false);
                                    else
                                      setState(() => _isUser = true);
                                  },
                                ),
                                Text(
                                  'Organization',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: GestureDetector(
                          child: Card(
                            elevation: 8,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            )),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 12),
                              child: Text(
                                'LOGIN',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          onTap: _validateLoginInput,
                        ),
                      ),
                      Spacer(),
                      GestureDetector(
                        onTap: () => _bottomSheet(context: context),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              ' SignUp',
                              style: TextStyle(
                                color: Color(0xFFF7EC03),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                    ]),
        ),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text(
                  'Register',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 40,
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
              .where('email', isEqualTo: emailController.text).get()
              .then((users) {
            // debugPrint(
            //     "USR ===> ${users.docs[0].data['displayName'].toString()}  ::  Gender: ${users.docs[0].data['gender']} : ${users.docs[0].id}");
            // bool status = users.docs[0].data['status'];
            // switch (status) {
            //   // Approved
            //   case true:
            //     _loginUser(userId: users.docs[0].id.toString());
            //     break;
            //   // DisApproved
            //   case false:
            //     setState(() {
            //       errorMsg = "Account Blocked!";
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
