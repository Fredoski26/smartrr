import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/utils/colors.dart';

class Settings extends StatelessWidget {
  // const Settings({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Container(
              height: 162 - AppBar().preferredSize.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: primaryColor),
              child: Container(),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 503,
                  width: 302,
                  padding: EdgeInsets.symmetric(horizontal: 11, vertical: 69),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(13),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            offset: Offset(0, 4),
                            blurRadius: 55)
                      ]),
                  child: ListView(children: [
                    ListTile(
                      leading: Icon(
                        Icons.password_outlined,
                        color: primaryColor,
                      ),
                      title: Text("Change Password"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: lightGrey,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.language,
                        color: primaryColor,
                      ),
                      title: Text("Language"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: lightGrey,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.public,
                        color: primaryColor,
                      ),
                      title: Text("Country"),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: lightGrey,
                      ),
                    ),
                    Divider(),
                    ListTile(
                      leading: Icon(
                        Icons.light_mode_outlined,
                        color: primaryColor,
                      ),
                      title: Text("Light Mode"),
                      trailing: CupertinoSwitch(
                        activeColor: primaryColor,
                        value: true,
                        onChanged: (val) {},
                      ),
                    )
                  ]),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
