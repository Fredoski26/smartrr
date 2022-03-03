import 'package:flutter/material.dart';
import '../../utils/colors.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 1,
      child: ListView(children: [
        ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text("About Smart RR"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text("History"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () {},
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text("Settings"),
          textColor: Colors.white,
          iconColor: Colors.white,
          onTap: () {},
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
          onTap: () {},
        )
      ]),
    );
  }
}
