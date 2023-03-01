import 'package:flutter/material.dart';

const Color smartYellow = Color(0xFFFCF200);
const Color dropDownCanvasColor = Colors.white;
const Color dropDownCanvasDarkColor = Color(0xFF333333);
const Color primaryColor = Color(0xFFF59405);
const Color darkGrey = Color(0xFF444444);
const Color lightGrey = Color(0xFFA59B9B);

Map<int, Color> color = {
  50: Color.fromRGBO(255, 255, 255, .1),
  100: Color.fromRGBO(255, 255, 255, .2),
  200: Color.fromRGBO(255, 255, 255, .3),
  300: Color.fromRGBO(255, 255, 255, .4),
  400: Color.fromRGBO(255, 255, 255, .5),
  500: Color.fromRGBO(255, 255, 255, .6),
  600: Color.fromRGBO(255, 255, 255, .7),
  700: Color.fromRGBO(255, 255, 255, .8),
  800: Color.fromRGBO(255, 255, 255, .9),
  900: Color.fromRGBO(255, 255, 255, 1),
};

MaterialColor materialWhite = MaterialColor(0xFFFFFFFF, color);
