import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

ThemeData appTheme = ThemeData(
    textTheme: GoogleFonts.poppinsTextTheme(),
    primarySwatch: Colors.orange,
    primaryColor: primaryColor,
    appBarTheme: AppBarTheme(
      backgroundColor: primaryColor,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 18),
      iconTheme: IconThemeData().copyWith(color: Colors.white),
    ),
    drawerTheme: DrawerThemeData(backgroundColor: primaryColor),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0)),
      side: MaterialStateProperty.all(
          BorderSide(width: 1.0, color: primaryColor)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))),
    )));

final ThemeData darkTheme = ThemeData(
    primarySwatch: Colors.orange,
    primaryColor: primaryColor,
    appBarTheme:
        appTheme.appBarTheme.copyWith(color: primaryColor, elevation: 0),
    scaffoldBackgroundColor: darkGrey,
    textTheme: appTheme.textTheme,
    // textTheme: TextTheme().copyWith(
    //     button: TextStyle().copyWith(color: Colors.white),
    //     headline6: TextStyle().copyWith(color: Colors.white),
    //     bodyText2: TextStyle().copyWith(color: Colors.white),
    //     caption: TextStyle().copyWith(color: Colors.grey),
    //     subtitle1: TextStyle().copyWith(color: Colors.white)),
    drawerTheme: DrawerThemeData().copyWith(backgroundColor: darkGrey),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        shape: MaterialStateProperty.all(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        foregroundColor: MaterialStateProperty.all(Colors.white),
        backgroundColor: MaterialStateProperty.all(primaryColor),
        padding: MaterialStateProperty.all(
            EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0)),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
      padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0)),
      side: MaterialStateProperty.all(
          BorderSide(width: 1.0, color: primaryColor)),
      shape: MaterialStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(33))),
    )));
