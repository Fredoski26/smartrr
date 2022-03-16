import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class AuthContainer extends StatefulWidget {
  AuthContainer({Key key, @required this.child, this.isOrgSignUp = false})
      : super(key: key);

  final Widget child;
  final isOrgSignUp;

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  final mScaffoldState = GlobalKey<ScaffoldState>();
  TextEditingController emailController;
  TextEditingController passwordController;
  String errorMsg;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: mScaffoldState,
      body: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Positioned(
              top: widget.isOrgSignUp ? -208 : -135,
              child: Container(
                height: 332.0,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(90),
                        bottomLeft: Radius.circular(90))),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(top: widget.isOrgSignUp ? 60 : 123),
                  padding: EdgeInsets.all(30),
                  width: 318,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    color: notifier.darkTheme ? darkGrey : Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: notifier.darkTheme
                            ? Colors.white.withOpacity(0.5)
                            : Color(0xFF444444).withOpacity(0.5),
                        offset: Offset(0, 4),
                        blurRadius: 122,
                      )
                    ],
                  ),
                  child: widget.child,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 109.0,
                  width: 109.0,
                  margin: EdgeInsets.only(top: widget.isOrgSignUp ? 0.0 : 63.0),
                  child: Image.asset("assets/logo.png"),
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
