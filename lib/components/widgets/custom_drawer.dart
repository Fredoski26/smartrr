import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';
import 'package:smartrr/components/widgets/ask_action.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/generated/l10n.dart';

class CustomDrawer extends StatelessWidget {
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    _stayHere() {
      Navigator.pop(context);
    }

    _logout() async {
      await FirebaseAuth.instance.signOut().then((_) {
        clearPrefs().then((_) => Navigator.pushNamedAndRemoveUntil(
            context, '/login', ModalRoute.withName('Login')));
      });
    }

    _confirmLogout() {
      askAction(
        actionText: 'Yes',
        cancelText: 'No',
        text: 'Do you want to logout?',
        context: context,
        func: _logout,
        cancelFunc: _stayHere,
      );
    }

    return Drawer(
      elevation: 1,
      child: ListView(children: [
        UserAccountsDrawerHeader(
            currentAccountPicture: _currentUser.photoURL != null
                ? Image.network(_currentUser.photoURL!)
                : Container(
                    margin: EdgeInsets.only(bottom: 10.0),
                    child: CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 60,
                      ),
                    ),
                  ),
            accountName: Text(_currentUser.displayName!),
            accountEmail: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_currentUser.email ?? ""),
                Text(_currentUser.phoneNumber ?? ""),
              ],
            )),
        ListTile(
          leading: Icon(Icons.history),
          title: Text(_language.history),
          onTap: () => Navigator.pushNamed(context, '/casesHistory'),
        ),
        ListTile(
          leading: Icon(Icons.history),
          title: Text("Period Tracker"),
          onTap: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => PeriodTracker())),
        ),
        ListTile(
          leading: Icon(Icons.shopping_bag_outlined),
          title: Row(
            children: [
              Text(_language.shop),
              // Container(
              //   margin: EdgeInsets.all(2),
              //   padding: EdgeInsets.all(10),
              //   decoration: BoxDecoration(
              //     color: Colors.purple.withOpacity(.1),
              //     borderRadius: BorderRadius.circular(20.0),
              //   ),
              //   child: Text(
              //     _language.new_,
              //     style:
              //         TextStyle().copyWith(color: Colors.purple, fontSize: 15),
              //   ),
              // ),
            ],
          ),
          onTap: () => Navigator.of(context).pushNamed("/shop"),
        ),
        ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text(_language.aboutSmartRR),
          onTap: () => Navigator.of(context).pushNamed("/about"),
        ),
        ListTile(
          leading: Icon(Icons.settings),
          title: Text(_language.settings),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
        ListTile(
          leading: Icon(Icons.question_mark_rounded),
          title: Text("FAQs"),
          onTap: () => Navigator.pushNamed(context, '/faq'),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(_language.logOut),
          onTap: _confirmLogout,
        )
      ]),
    );
  }
}
