import 'package:firebase_auth/firebase_auth.dart';

class AuthUser {
  final bool? isUser;
  final User? user;

  AuthUser({required this.user, required this.isUser});
}
