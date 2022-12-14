import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/utils/utils.dart';

class AuthService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;

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
