import 'package:flutter_svg/flutter_svg.dart';

abstract class SmartIcons {
  static SvgPicture get Home => SvgPicture.asset("assets/icons/home.svg");
  static SvgPicture get HomeActive =>
      SvgPicture.asset("assets/icons/home-active.svg");
  static SvgPicture get Cart => SvgPicture.asset("assets/icons/cart.svg");
  static SvgPicture get CartActive =>
      SvgPicture.asset("assets/icons/cart-active.svg");
  static SvgPicture get Message =>
      SvgPicture.asset("assets/icons/invite_minor.svg");
  static SvgPicture get MessageActive =>
      SvgPicture.asset("assets/icons/message-active.svg");
  static SvgPicture get Profile => SvgPicture.asset("assets/icons/user.svg");
  static SvgPicture get ProfileActive =>
      SvgPicture.asset("assets/icons/profile-active.svg");
}
