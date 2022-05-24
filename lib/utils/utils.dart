import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum More { logout }

Future setUserIdPref({String userId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isUser", true);
  await prefs.setString("userId", userId);
}

Future<String> getUserIdPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userId");
}

Future setOrgIdPref({String orgId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isUser", false);
  await prefs.setString("orgId", orgId);
}

Future<String> getOrgIdPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("orgId");
}

Future<bool> getIsUserPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isUser");
}

Future clearPrefs({String orgId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isUser", false);
  await prefs.remove("orgId");
  await prefs.remove("userId");
}

Future setUserTypePref({bool userType}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("userType", userType);
}

Future<bool> getUserTypePref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("userType");
}

Future setTheme({bool isDarkMode}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", isDarkMode);
}

Future<bool> getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic isDarkTheme = prefs.getBool("isDarkTheme");
  if (isDarkTheme == null) isDarkTheme = true;

  return isDarkTheme;
}

texts({String title, String value}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 14),
        ),
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

String birthDateValidator(String value) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy', "en");
  final String formatted = formatter.format(now);
  String str1 = value;
  List<String> str2 = str1.split('-');
  String day = str2.isNotEmpty ? str2[0] : '';
  String month = str2.length > 1 ? str2[1] : '';
  String year = str2.length > 2 ? str2[2] : '';
  print(value);
  if (value.isEmpty) {
    return 'Must be DD-MM-YYYY';
  } else if (int.parse(month) > 13) {
    return 'Must be DD-MM-YYYY';
  } else if (int.parse(day) > 32) {
    return 'Must be DD-MM-YYYY';
  } else if ((int.parse(year) > int.parse(formatted))) {
    return 'Must be DD-MM-YYYY';
  } else if ((int.parse(year) < 1920)) {
    return 'Must be DD-MM-YYYY';
  }
  return null;
}
