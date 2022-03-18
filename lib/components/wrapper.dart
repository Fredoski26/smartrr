import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/components/screens/general/login_page.dart';
import 'package:smartrr/components/screens/org/refer_or_cases_page.dart';
import 'package:smartrr/components/screens/user/report_or_history_page.dart';
import 'package:smartrr/models/auth_user.dart';
import 'package:smartrr/utils/utils.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key key, @required this.isDarkTheme}) : super(key: key);

  final bool isDarkTheme;

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthUser>(
        stream: _getData().asStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.isUser) {
              return ReportOrHistoryPage();
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
    User currentUser = FirebaseAuth.instance.currentUser;
    bool isUser = await getIsUserPref();

    if (currentUser == null) {
      return null;
    } else {
      return AuthUser(user: currentUser, isUser: isUser);
    }
  }
}
