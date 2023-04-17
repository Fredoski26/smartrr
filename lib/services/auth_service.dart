import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/components/widgets/ask_action.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/utils/constants.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:smartrr/env/env.dart';

abstract class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  static Future logOutUser(BuildContext context) async {
    askAction(
      actionText: 'Yes',
      cancelText: 'No',
      text: 'Do you want to logout?',
      context: context,
      func: () async {
        await FirebaseAuth.instance.signOut().then((_) {
          Hive.box(kconfigBox).clear();
          Hive.box(kmessageBox).clear();
          Hive.box(kcartBox).clear();
          Hive.box(knotificationBox).clear();
          clearPrefs().then(
            (_) => Navigator.pushNamedAndRemoveUntil(
              context,
              '/login',
              ModalRoute.withName('Login'),
            ),
          );
        });
      },
      cancelFunc: () => Navigator.pop(context),
    );
  }

  static String generateApiToken() {
    final jwt = JWT({"client": "mobile"});
    final expiresIn = Duration(seconds: 30);
    final token = jwt.sign(SecretKey(Env.jwtSecret), expiresIn: expiresIn);

    return token;
  }

  static Future handleSignInWithPhone({
    required PhoneAuthCredential credential,
    required BuildContext context,
  }) async {
    UserCredential userCredential =
        await _auth.signInWithCredential(credential);

    final users = await FirebaseFirestore.instance
        .collection("users")
        .where("uId", isEqualTo: userCredential.user!.uid)
        .get();

    await setUserIdPref(
        userId: userCredential.user!.uid, userDocId: users.docs[0].id);

    await DatabaseService().setDeviceToken(user: userCredential.user!);

    return true;
  }

  static Future updatePassword({required String password}) async {
    try {
      await _auth.currentUser!.updatePassword(password);
    } catch (e) {
      return null;
    }
  }

  static Future handlePhoneAuthCredentials({
    required Map userData,
    required PhoneAuthCredential credential,
    required BuildContext context,
  }) async {
    if (userData["email"] != "" && userData["email"] != null) {
      // link email with phone number
      await _linkCredentials(
          credential: credential, context: context, userData: userData);
    } else {
      UserCredential auth = await _auth.signInWithCredential(credential);

      userData["uId"] = auth.user!.uid;
      await _updateUser(uid: auth.user!.uid, update: userData);
      await setUserIdPref(userId: auth.user!.uid, userDocId: auth.user!.uid);
    }
  }

  // link email with phone number
  static Future _linkCredentials(
      {required PhoneAuthCredential credential,
      required Map userData,
      required BuildContext context}) async {
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: userData["email"], password: userData["password"]);

    userCredential.user!.linkWithCredential(credential);

    await _updateUser(uid: userCredential.user!.uid, update: userData);
    await setUserIdPref(
        userId: userCredential.user!.uid, userDocId: userCredential.user!.uid);
  }

  static Future _updateUser({required String uid, required Map update}) async {
    update.remove("password");
    update.addAll({"uId": uid});

    HashMap<String, Object> userData = HashMap.from(update);
    await _auth.currentUser!
        .updateDisplayName(update["displayName"])
        .then((onValue) {
      FirebaseFirestore.instance.collection('users').doc(uid).set(userData);
    });
  }
}
