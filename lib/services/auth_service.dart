import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:smartrr/utils/utils.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future updatePassword({String password}) async {
    try {
      await _auth.currentUser.updatePassword(password);
    } catch (e) {
      return null;
    }
  }

  static Future signUpWithPhoneWeb(String phoneNumber) async {
    _auth.signInWithPhoneNumber(phoneNumber);
  }

  static Future signInWithPhone(
      {@required String phoneNumber, @required BuildContext context}) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _handleSignInWithPhone(credential: credential, context: context);
      },
      verificationFailed: (FirebaseAuthException e) {
        print(e.toString());
        switch (e.code) {
          case 'invalid-phone-number':
            showToast(
                msg: 'The provided phone number is not valid', type: "error");
            break;
          default:
            showToast(msg: e.message, type: "error");
            break;
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        final formKey = GlobalKey<FormState>();
        final pinController = TextEditingController();

        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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
                                context: context, credential: credential);
                          },
                          validator: (pin) => pin.length < 6 || pin.length > 6
                              ? "Invalid code"
                              : null)),
                  SizedBox(height: 5.0),
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: pinController.text);

                          await _handleSignInWithPhone(
                              context: context, credential: credential);
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
  }

  static Future signUpWithPhoneMobile({
    @required String phoneNumber,
    @required BuildContext context,
    @required Map userData,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _handlePhoneAuthCredentials(
          credential: credential,
          userData: userData,
          context: context,
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        switch (e.code) {
          case 'invalid-phone-number':
            showToast(
                msg: 'The provided phone number is not valid', type: "error");
            break;
          default:
            showToast(msg: e.message, type: "error");
            break;
        }
      },
      codeSent: (String verificationId, int resendToken) async {
        final formKey = GlobalKey<FormState>();
        final pinController = TextEditingController();

        showDialog(
          context: context,
          builder: (context) => Dialog(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
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

                            await _handlePhoneAuthCredentials(
                              credential: credential,
                              userData: userData,
                              context: context,
                            );
                          },
                          validator: (pin) => pin.length < 6 || pin.length > 6
                              ? "Invalid code"
                              : null)),
                  SizedBox(height: 5.0),
                  ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState.validate()) {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                                  verificationId: verificationId,
                                  smsCode: pinController.text);

                          await _handlePhoneAuthCredentials(
                            credential: credential,
                            userData: userData,
                            context: context,
                          );
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
  }

  static _handleSignInWithPhone(
      {PhoneAuthCredential credential, BuildContext context}) async {
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);
    await setUserIdPref(userId: userCredential.user.uid);

    Navigator.pushNamedAndRemoveUntil(
        context, '/userMain', ModalRoute.withName('Dashboard'));
  }

  static Future _handlePhoneAuthCredentials({
    @required Map userData,
    @required PhoneAuthCredential credential,
    @required BuildContext context,
  }) async {
    if (userData["email"] != "" && userData["email"] != null) {
      // link email with phone number
      await _linkCredentials(
          credential: credential, context: context, userData: userData);
    } else {
      UserCredential auth = await _auth.signInWithCredential(credential);

      userData["uId"] = auth.user.uid;
      await _updateUser(uid: auth.user.uid, update: userData);
      await setUserIdPref(userId: auth.user.uid);

      Navigator.pushNamedAndRemoveUntil(
          context, '/userMain', ModalRoute.withName('Dashboard'));
      ;
    }
  }

  // link email with phone number
  static Future _linkCredentials(
      {PhoneAuthCredential credential,
      Map userData,
      @required BuildContext context}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData["email"], password: userData["password"]);

    userCredential.user.linkWithCredential(credential);

    await _updateUser(uid: userCredential.user.uid, update: userData);
    await setUserIdPref(userId: userCredential.user.uid);

    Navigator.pushNamedAndRemoveUntil(
        context, '/userMain', ModalRoute.withName('Dashboard'));
    ;
  }

  static Future _updateUser(
      {@required String uid, @required Map update}) async {
    update.remove("password");
    update.addAll({"uId": uid});

    HashMap<String, Object> userData = HashMap.from(update);
    await _auth.currentUser
        .updateDisplayName(update["displayName"])
        .then((onValue) {
      FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
    });
  }
}
