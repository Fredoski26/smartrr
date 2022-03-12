import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/utils/colors.dart';
import '../../services/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String country = "Nigeria";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier notifier, child) => Container(
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
                        color: notifier.darkTheme ? darkGrey : Colors.white,
                        borderRadius: BorderRadius.circular(13),
                        boxShadow: [
                          BoxShadow(
                              color: notifier.darkTheme
                                  ? Colors.white.withOpacity(0.18)
                                  : Colors.black.withOpacity(0.18),
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
                      ),
                      Divider(),
                      ListTile(
                          leading: Icon(
                            Icons.language,
                            color: primaryColor,
                          ),
                          title: Text("Language"),
                          trailing: Text("English")),
                      Divider(),
                      ListTile(
                          leading: Icon(
                            Icons.public,
                            color: primaryColor,
                          ),
                          title: Text("Country"),
                          trailing: StreamBuilder(
                              stream: DatabaseService(uid: "uid")
                                  .getUser()
                                  .asStream(),
                              builder: (context, snapshot) =>
                                  snapshot.hasData ? Text(country) : Text("-")),
                          onTap: () =>
                              Navigator.of(context).pushNamed("/countries")),
                      Divider(),
                      ListTile(
                        leading: Icon(
                          Icons.light_mode_outlined,
                          color: primaryColor,
                        ),
                        title: Text("Dark Mode"),
                        trailing: CupertinoSwitch(
                          activeColor: primaryColor,
                          value: notifier.darkTheme,
                          onChanged: (val) {
                            notifier.toggleTheme();
                          },
                        ),
                      )
                    ]),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
