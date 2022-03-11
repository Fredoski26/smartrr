import 'package:flutter/material.dart';
import '../../utils/colors.dart';
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
        ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text("About Smart RR"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () => Navigator.of(context).pushNamed("/about"),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text("History"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () => Navigator.pushNamed(context, '/casesHistory'),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        ListTile(
          leading: Icon(Icons.question_mark_rounded),
          title: Text("FAQs"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text("Log Out"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: _logout,
        )
      ]),
    );
  }
}
