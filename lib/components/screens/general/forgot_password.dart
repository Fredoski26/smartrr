import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/show_loading.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/emailValidator.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> formKey = new GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  TextEditingController _email = TextEditingController();
  bool isLoading = false;
  final _auth = FirebaseAuth.instance;

  submit() async {
    final FormState form = formKey.currentState!;
    if (form.validate()) {
      form.save();
      _sendResetEmail();
    }
  }

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
        builder: (context, langNotifier, child) => Scaffold(
              resizeToAvoidBottomInset: false,
              body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(
                        top: 10,
                        bottom: 30,
                        left: 25,
                        right: 25,
                      ),
                      margin: EdgeInsets.only(bottom: 63),
                      decoration: BoxDecoration(
                        color: inputBackground,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Form(
                        key: formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                onPressed: () => Navigator.pop(context),
                                icon: Container(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 1,
                                        color: red,
                                      ),
                                      borderRadius: BorderRadius.circular(100),
                                      boxShadow: [
                                        BoxShadow(
                                          color: red.withOpacity(0.1),
                                        )
                                      ]),
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: red,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              _language.forgotPassword,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(bottom: 27, top: 6),
                              child: Text(
                                _language.forgotPasswordDescription,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextFormField(
                              controller: _email,
                              keyboardType: TextInputType.emailAddress,
                              validator: (email) =>
                                  EmailValidator.isValidEmail(email!)
                                      ? null
                                      : "Invalid email",
                              decoration: InputDecoration(
                                hintText: "Email Address",
                                hintStyle:
                                    TextStyle().copyWith(color: faintGrey),
                                fillColor: materialWhite,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 20),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextButton(
                            onPressed: submit,
                            child: Text(_language.sendResetLink),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(33))),
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.white),
                              backgroundColor:
                                  MaterialStateProperty.all(primaryColor),
                              padding: MaterialStateProperty.all(
                                  EdgeInsets.all(5.0)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ));
  }

  void _sendResetEmail() {
    showLoading(message: "Please wait", context: context);
    bool _isError = false;
    _auth.sendPasswordResetEmail(email: _email.text).catchError(
      (onError) {
        debugPrint("Error ===> ${onError.code}");
        _isError = true;
        if (onError.code == 'user-not-found') {
          showAction(
            actionText: 'OK',
            text: 'User Not Found',
            func: () => Navigator.pop(context),
            context: context,
          );
          setState(() => isLoading = false);
        } else {
          showAction(
            actionText: 'OK',
            text: 'Something went wrong!',
            func: () => Navigator.pop(context),
            context: context,
          );
          setState(() => isLoading = false);
        }
      },
    ).then((value) async {
      if (!_isError) {
        setState(() => isLoading = false);
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
