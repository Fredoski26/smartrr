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
      appBar: AppBar(title: Text("Forgot Password")),
      resizeToAvoidBottomInset: false,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 18),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
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
                    color: Color(0xFF575555),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 13),
                Text(
                  "Enter the email address associated with your Amrt RR account aand we will send a reset password link",
                  style: TextStyle(
                    color: Color(0xFF444444),
                    fontSize: 14,
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
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: submit,
                        child: Text("Send Reset Link"),
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(33))),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xFFF59405)),
                          padding:
                              MaterialStateProperty.all(EdgeInsets.all(5.0)),
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