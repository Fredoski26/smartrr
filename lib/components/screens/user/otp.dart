import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/main_wrapper.dart';
import 'package:smartrr/components/widgets/show_loading.dart';
import 'package:smartrr/services/auth_service.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:pinput/pinput.dart';

class OTPScreen extends StatefulWidget {
  final String verificationId;
  const OTPScreen({super.key, required this.verificationId});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();
  late TextEditingController pinController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 35.0),
              margin: EdgeInsets.only(bottom: 63),
              decoration: BoxDecoration(
                color: inputBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Verification Code",
                        style: TextStyle().copyWith(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                  SizedBox(height: 24.0),
                  Form(
                      key: formKey,
                      child: Pinput(
                        length: 6,
                        controller: pinController,
                        defaultPinTheme: PinTheme(
                            height: 50,
                            width: 50,
                            textStyle: TextStyle().copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 24,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: materialWhite,
                            )),
                        onSubmitted: (pin) async {
                          try {
                            PhoneAuthCredential credential =
                                PhoneAuthProvider.credential(
                              verificationId: widget.verificationId,
                              smsCode: pin,
                            );

                            await AuthService.handleSignInWithPhone(
                              context: context,
                              credential: credential,
                            );

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MainWrapper(),
                              ),
                              ModalRoute.withName("/userMain"),
                            );
                          } catch (e) {
                            Navigator.pop(context);
                            _handlePhoneAuthError(e);
                          }
                        },
                        validator: (pin) => pin!.length < 6 || pin.length > 6
                            ? "Invalid code"
                            : null,
                      )),
                  SizedBox(height: 5.0)
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        showLoading(message: "Logging in...", context: context);
                        try {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: pinController.text,
                          );

                          await AuthService.handleSignInWithPhone(
                              context: context, credential: credential);

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainWrapper(),
                            ),
                            ModalRoute.withName("/userMain"),
                          );
                        } catch (e) {
                          Navigator.pop(context);
                          _handlePhoneAuthError(e);
                        }
                      }
                    },
                    child: Text("Continue"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _handlePhoneAuthError(dynamic error) {
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

  @override
  void initState() {
    pinController = new TextEditingController();
    super.initState();
  }
}
