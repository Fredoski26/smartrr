import 'package:flutter_svg/flutter_svg.dart';

abstract class SmartIcons {
  static get Home => SvgPicture.asset("assets/icons/home.svg");
  static get HomeActive => SvgPicture.asset("assets/icons/home-active.svg");
  static get Cart => SvgPicture.asset("assets/icons/cart.svg");
  static get CartActive => SvgPicture.asset("assets/icons/cart-active.svg");
  static get Message => SvgPicture.asset("assets/icons/invite_minor.svg");
  static get MessageActive =>
      SvgPicture.asset("assets/icons/message-active.svg");
  static get Profile => SvgPicture.asset("assets/icons/user.svg");
  static get ProfileActive =>
      SvgPicture.asset("assets/icons/profile-active.svg");
}
