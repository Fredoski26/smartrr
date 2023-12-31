import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class AuthContainer extends StatefulWidget {
  AuthContainer({super.key, required this.child, this.isOrgSignUp = false});

  final Widget child;
  final isOrgSignUp;

  @override
  State<AuthContainer> createState() => _AuthContainerState();
}

class _AuthContainerState extends State<AuthContainer> {
  final mScaffoldState = GlobalKey<ScaffoldState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late String errorMsg;
  bool isLoading = false;

  final _appBarHeight = AppBar().preferredSize.height;

  @override
  Widget build(BuildContext context) {
    final _containerWidth = MediaQuery.of(context).size.width -
        (MediaQuery.of(context).size.width / 100 * 10);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: mScaffoldState,
      appBar: widget.isOrgSignUp ? null : AppBar(actions: [LanguagePicker()]),
      body: Consumer<ThemeNotifier>(
        builder: (context, notifier, child) => Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Positioned(
              top: -135,
              child: Container(
                height: 332.0 - _appBarHeight,
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
                  margin: EdgeInsets.only(
                      top: widget.isOrgSignUp ? 55 : 123 - _appBarHeight),
                  padding: EdgeInsets.all(20),
                  width: _containerWidth,
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
                  height: 90.0,
                  width: 90.0,
                  margin: EdgeInsets.only(
                      top: widget.isOrgSignUp ? 0.0 : 63.0 - _appBarHeight),
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
