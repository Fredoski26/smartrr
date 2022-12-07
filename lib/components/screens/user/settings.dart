import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/select_country.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/smart_text_field.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/auth_service.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/utils/colors.dart';
import '../../../services/theme_provider.dart';
import 'package:smartrr/generated/l10n.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});
  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String country = "";

  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    DatabaseService().getUser().then((user) {
      if (mounted) {
        setState(() {
          country = user["country"] ?? "Nigeria";
        });
      }
    });

    return Consumer<LanguageNotifier>(
        builder: (context, _, child) => Scaffold(
              appBar: AppBar(title: Text(_language.settings)),
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
                            padding: EdgeInsets.symmetric(
                                horizontal: 11, vertical: 69),
                            decoration: BoxDecoration(
                                color: notifier.darkTheme
                                    ? darkGrey
                                    : Colors.white,
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
                                title: Text(_language.changePassword),
                                onTap: () => _changePasswordDialod(
                                    context, notifier.darkTheme),
                              ),
                              Divider(),
                              ListTile(
                                  leading: Icon(
                                    Icons.language,
                                    color: primaryColor,
                                  ),
                                  title: Text(_language.language),
                                  trailing: LanguagePicker()),
                              Divider(),
                              ListTile(
                                  leading: Icon(
                                    Icons.public,
                                    color: primaryColor,
                                  ),
                                  title: Text(
                                    _language.country,
                                    softWrap: false,
                                  ),
                                  trailing: country.isEmpty
                                      ? Container(
                                          child: CircularProgressIndicator(),
                                          height: 20.0,
                                          width: 20.0,
                                        )
                                      : Text(
                                          country,
                                          textAlign: TextAlign.right,
                                          maxLines: 2,
                                          overflow: TextOverflow.fade,
                                        ),
                                  onTap: () => Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) => SelectCountry(
                                                userCountry: country,
                                              )))),
                              Divider(),
                              ListTile(
                                leading: Icon(
                                  Icons.light_mode_outlined,
                                  color: primaryColor,
                                ),
                                title: Text(_language.darkMode),
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
            ));
  }

  _submitPassword(String password, String confirmPassword) async {
    if (_formKey.currentState!.validate()) {
      if (password != confirmPassword) {
        Fluttertoast.showToast(
          msg: "Passwords don't match",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return null;
      }
      await AuthService.updatePassword(password: password);
      Navigator.pop(context);
    } else {
      return null;
    }
  }

  _changePasswordDialod(BuildContext context, bool isDarkTheme) {
    return showDialog(
        context: context,
        builder: (context) => Dialog(
              backgroundColor: isDarkTheme ? darkGrey : Colors.white,
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          S.of(context).changePassword,
                          textAlign: TextAlign.center,
                          style: TextStyle().copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.0),
                        smartTextField(
                            title: S.of(context).password,
                            controller: _passwordController,
                            obscure: true,
                            isForm: true),
                        smartTextField(
                            title: S.of(context).confirmPassword,
                            controller: _confirmPasswordController,
                            obscure: true,
                            isForm: true),
                        Row(
                          children: [
                            Expanded(
                                child: TextButton(
                                    onPressed: () => _submitPassword(
                                        _passwordController.text,
                                        _confirmPasswordController.text),
                                    child: Text(S.of(context).update))),
                          ],
                        )
                      ],
                    )),
              ),
            ));
  }
}
