import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/components/screens/general/login_page.dart';
import 'package:smartrr/components/screens/org/refer_or_cases_page.dart';
import 'package:smartrr/models/auth_user.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:smartrr/components/screens/main_wrapper.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser>(
        stream: _getData().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data?.user != null) {
            if (DatabaseService().getDeviceToken == null) {
              DatabaseService().setDeviceToken(snapshot.data!.user!);
            }
            if (snapshot.data!.isUser!) {
              return MainWrapper();
            } else {
              return ReferOrCasesPage();
            }
          } else {
            return LoginPage();
          }
        });
  }

  Future<AuthUser> _getData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    bool isUser = await getIsUserPref();

    return AuthUser(user: currentUser, isUser: isUser);
  }
}
