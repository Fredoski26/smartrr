import 'package:flutter/material.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _logout() async {
      debugPrint('Logged Out!');
      await FirebaseAuth.instance.signOut().then((_) {
        clearPrefs().then((_) => Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('Login')));
      });
    }

    return Drawer(
      elevation: 1,
      child: ListView(children: [
        UserAccountsDrawerHeader(
            accountName: Text("Account"), accountEmail: Text("EMail")),
        ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text("About Smart RR"),
          onTap: () => Navigator.of(context).pushNamed("/about"),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text("History"),
          onTap: () => Navigator.pushNamed(context, '/casesHistory'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        ListTile(
          leading: Icon(Icons.question_mark_rounded),
          title: Text("FAQs"),
          onTap: () => Navigator.pushNamed(context, '/faq'),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Log Out"),
          onTap: _logout,
        )
      ]),
    );
  }
}
