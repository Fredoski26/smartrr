import 'package:flutter_svg/flutter_svg.dart';

abstract class SmartIcons {
  static get Home => SvgPicture.asset("assets/icons/home.svg");
  static get HomeActive => SvgPicture.asset("assets/icons/home-active.svg");
  static get Cart => SvgPicture.asset("assets/icons/cart.svg");
  static get CartActive => SvgPicture.asset("assets/icons/cart-active.svg");
}
