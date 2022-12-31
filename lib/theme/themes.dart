import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/colors.dart';

final ThemeData appTheme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme()
      .copyWith(bodyText1: TextStyle().copyWith(fontSize: 16)),
  primarySwatch: Colors.orange,
  primaryColor: primaryColor,
  iconTheme: IconThemeData().copyWith(color: Colors.white),
  appBarTheme: AppBarTheme(
    backgroundColor: primaryColor,
    elevation: 0,
    centerTitle: true,
    titleTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 20),
    iconTheme: IconThemeData().copyWith(color: Colors.white),
    toolbarTextStyle: TextStyle().copyWith(color: Colors.white),
  ),
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
    ),
  ),
  tabBarTheme: TabBarTheme().copyWith(),
);

final ThemeData darkTheme = ThemeData(
  primarySwatch: Colors.orange,
  primaryColor: primaryColor,
  canvasColor: darkGrey,
  appBarTheme: appTheme.appBarTheme.copyWith(color: primaryColor, elevation: 0),
  scaffoldBackgroundColor: darkGrey,
  textTheme: appTheme.textTheme
      .apply(bodyColor: Colors.white, displayColor: Colors.white),
  drawerTheme: DrawerThemeData().copyWith(backgroundColor: darkGrey),
  iconTheme: appTheme.iconTheme,
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
    ),
  ),
  listTileTheme: ListTileThemeData(iconColor: Colors.white),
  popupMenuTheme: PopupMenuThemeData(
      textStyle: TextStyle().copyWith(color: Colors.white), color: darkGrey),
  bottomSheetTheme: BottomSheetThemeData()
      .copyWith(backgroundColor: darkGrey, modalBackgroundColor: darkGrey),
  dialogBackgroundColor: darkGrey,
  inputDecorationTheme: InputDecorationTheme()
      .copyWith(hintStyle: TextStyle().copyWith(color: lightGrey)),
  backgroundColor: darkGrey,
  cardTheme: CardTheme().copyWith(color: darkGrey),
);
