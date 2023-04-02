import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/ask_action.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:smartrr/utils/utils.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late User _currentUser;

  Widget UserDataField(String key, String value) {
    return Container(
      margin: EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Text(key),
          Divider(),
          Text(
            value,
            style: TextStyle().copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  final ButtonStyle _textButtonStyle = ButtonStyle(
    backgroundColor: MaterialStatePropertyAll(Colors.transparent),
    foregroundColor: MaterialStatePropertyAll(faintGrey),
  );

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Scaffold(
        body: ListView(
          padding: EdgeInsets.only(top: 100),
          children: [
            CircleAvatar(
              radius: 50,
              child: _currentUser.photoURL != null
                  ? Image.network(_currentUser.photoURL!)
                  : Icon(
                      Icons.person,
                      size: 50,
                    ),
            ),
            Align(
              child: Container(
                width: 237,
                margin: EdgeInsets.only(top: 78),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: theme.darkTheme ? darkGrey : materialWhite,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Column(
                  children: [
                    UserDataField(
                      "Firstname",
                      _currentUser.displayName?.split(" ")[0] ?? "",
                    ),
                    UserDataField(
                      "Lastname",
                      _currentUser.displayName?.split(" ")[1] ?? "",
                    ),
                    UserDataField(
                      "Email",
                      _currentUser.email ?? "",
                    ),
                    UserDataField(
                      "Phone",
                      _currentUser.phoneNumber ?? "",
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 50),
            Align(
              child: Column(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/faq");
                    },
                    icon: Icon(Icons.question_mark_rounded),
                    label: Text("FAQ"),
                    style: _textButtonStyle,
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, "/settings");
                    },
                    icon: Icon(Icons.settings),
                    label: Text(S.current.settings),
                    style: _textButtonStyle,
                  ),
                  TextButton.icon(
                    onPressed: _logout,
                    icon: Icon(Icons.logout),
                    label: Text(S.current.logOut),
                    style: _textButtonStyle,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  _logout() {
    askAction(
      actionText: 'Yes',
      cancelText: 'No',
      text: 'Do you want to logout?',
      context: context,
      func: () async {
        await FirebaseAuth.instance.signOut().then((_) {
          Hive.box("config").clear();
          clearPrefs().then((_) => Navigator.pushNamedAndRemoveUntil(
              context, '/login', ModalRoute.withName('Login')));
        });
      },
      cancelFunc: () => Navigator.pop(context),
    );
  }

  @override
  void initState() {
    _currentUser = FirebaseAuth.instance.currentUser!;
    super.initState();
  }
}
