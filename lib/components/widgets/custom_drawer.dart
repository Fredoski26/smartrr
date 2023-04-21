import 'package:flutter/material.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker.dart';
import 'package:smartrr/components/screens/period_tracker/period_tracker_wrapper.dart';
import 'package:smartrr/components/screens/shop/orders.dart';
import 'package:smartrr/components/widgets/ask_action.dart';
import 'package:smartrr/services/auth_service.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/generated/l10n.dart';

class CustomDrawer extends StatelessWidget {
  final User _currentUser = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Drawer(
      elevation: 1,
      child: ListView(children: [
        UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: secondaryColor),
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
          leading: Icon(Icons.shopping_cart_outlined),
          title: Text(_language.orders),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Orders(),
            ),
          ),
        ),
        ListTile(
          leading: Icon(Icons.info_outline_rounded),
          title: Text(_language.aboutSmartRR),
          onTap: () => Navigator.of(context).pushNamed("/about"),
        ),
        ListTile(
          leading: Icon(Icons.question_mark_rounded),
          title: Text("FAQs"),
          onTap: () => Navigator.pushNamed(context, '/faq'),
        ),
        ListTile(
          leading: Icon(Icons.logout),
          title: Text(_language.logOut),
          onTap: () => AuthService.logOutUser(context),
        )
      ]),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    );
  }
}
