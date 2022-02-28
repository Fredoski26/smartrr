import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/circular_progress.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  submit() async {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      _sendResetEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Form(
          key: formKey,
          child: Container(
            padding: EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                smartTextField(
                  title: 'Email',
                  controller: _email,
                  isForm: true,
                  textInputType: TextInputType.emailAddress,
                ),
                SizedBox(
                  height: 30,
                ),
                Align(
                  alignment: Alignment.center,
                  child: AnimatedContainer(
                    height: 50,
                    width:
                        _isLoading ? 80 : MediaQuery.of(context).size.width / 2,
                    duration: Duration(milliseconds: 500),
                    child: ButtonTheme(
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0)),
                        elevation: 0.0,
                        color: Colors.white,
                        child: _isLoading
                            ? CircularProgress()
                            : Text(
                                'DONE',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                        onPressed: submit,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new Text(
                      "Already a member? ",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    new InkWell(
                      onTap: () => Navigator.pop(context),
                      child: new Text(
                        "Login",
                        style: TextStyle(
                          color: Color(0xFFF7EC03),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _sendResetEmail() {
    setState(() => _isLoading = true);
    bool _isError = false;
    _auth.sendPasswordResetEmail(email: _email.text).catchError(
      (onError) {
        debugPrint("Error ===> ${onError.code}");
        _isError = true;
        if (onError.code == 'ERROR_USER_NOT_FOUND') {
          showAction(
            actionText: 'OK',
            text: 'User Not Found',
            func: () => Navigator.pop(context),
            context: context,
          );
          setState(() => _isLoading = false);
        } else {
          showAction(
            actionText: 'OK',
            text: 'Something went wrong!',
            func: () => Navigator.pop(context),
            context: context,
          );
          setState(() => _isLoading = false);
        }
      },
    ).then((value) async {
      if (!_isError) {
        setState(() => _isLoading = false);
        showAction(
          actionText: 'OK',
          text: 'Email sent, Check your Inbox to change password',
          func: () {
            Navigator.pop(context);
            Navigator.pop(context);
          },
          context: context,
        );
      }
    });
  }
}
