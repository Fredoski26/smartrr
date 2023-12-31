import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartrr/utils/colors.dart';

enum More { logout }

Future setUserIdPref(
    {required String userId, required String userDocId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isUser", true);
  await prefs.setString("userId", userId);
  await _setUserDocId(userDocId: userDocId);
}

Future _setUserDocId({required String userDocId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setString('userDocId', userDocId);
}

Future getUserDocIdPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userDocId");
}

Future<String> getUserIdPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("userId")!;
}

Future setOrgIdPref({required String orgId, String? orgDocId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isUser", false);
  await prefs.setString("orgId", orgId);
}

Future getOrgDocId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return await prefs.getString("orgDocId");
}

Future<String> getOrgIdPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString("orgId")!;
}

Future<bool> getIsUserPref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("isUser")!;
}

Future clearPrefs({String? orgId}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isUser", false);
  await prefs.remove("orgId");
  await prefs.remove("userId");
}

Future setUserTypePref({required bool userType}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("userType", userType);
}

Future<bool> getUserTypePref() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool("userType")!;
}

Future setTheme({required bool isDarkMode}) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool("isDarkMode", isDarkMode);
}

Future<bool> getTheme() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  dynamic isDarkTheme = prefs.getBool("isDarkTheme");
  if (isDarkTheme == null) isDarkTheme = true;

  return isDarkTheme;
}

texts({required String title, required String value}) {
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

dynamic birthDateValidator(String value) {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('yyyy', "en");
  final String formatted = formatter.format(now);
  String str1 = value;
  List<String> str2 = str1.split('-');
  String day = str2.isNotEmpty ? str2[0] : '';
  String month = str2.length > 1 ? str2[1] : '';
  String year = str2.length > 2 ? str2[2] : '';

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

Color _toastBackgroundColor(String type) {
  if (type == "error") return Colors.red;
  if (type == "success")
    return Colors.green;
  else
    return darkGrey;
}

showToast({required String msg, String type = "info"}) {
  Fluttertoast.showToast(
    msg: msg,
    backgroundColor: _toastBackgroundColor(type),
    gravity: ToastGravity.TOP,
    toastLength: Toast.LENGTH_LONG,
  );
}
