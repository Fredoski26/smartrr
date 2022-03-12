import 'package:firebase_auth/firebase_auth.dart';

abstract class Authentication {
  FirebaseAuth _auth = FirebaseAuth.instance;

  UpdatePassword({String password}) async {
    try {
      _auth.currentUser.updatePassword(password);
    } catch (e) {
      return null;
    }
  }
}
