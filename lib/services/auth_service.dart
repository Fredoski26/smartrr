import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static Future updatePassword({String password}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;

    try {
      await _auth.currentUser.updatePassword(password);
    } catch (e) {
      return null;
    }
  }
}
