import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/components/screens/general/login_page.dart';
import 'package:smartrr/components/screens/org/refer_or_cases_page.dart';
import 'package:smartrr/components/screens/user/home.dart';
import 'package:smartrr/models/auth_user.dart';
import 'package:smartrr/utils/utils.dart';

class Wrapper extends StatefulWidget {
  final bool isDarkTheme;

  const Wrapper({super.key, required this.isDarkTheme});

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser>(
        stream: _getData().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data?.user != null) {
            if (snapshot.data!.isUser!) {
              return Home();
            } else {
              return ReferOrCasesPage();
            }
          } else {
            return LoginPage(
              isDarkTheme: widget.isDarkTheme,
            );
          }
        });
  }

  Future<AuthUser> _getData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    bool isUser = await getIsUserPref();

    return AuthUser(user: currentUser, isUser: isUser);
  }
}
