import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/impact_of_smartrr.dart';
import 'package:smartrr/components/screens/user/select_service_page.dart';
import 'package:smartrr/components/widgets/chatbot.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/speech_to_text.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'consent_form_page.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final mScaffoldState = GlobalKey<ScaffoldState>();
  final User _currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
      builder: (context, _, child) => Scaffold(
        key: mScaffoldState,
        appBar: AppBar(
          title: Text(
            "Smart RR",
            style: TextStyle().copyWith(
              color: primaryColor,
              fontWeight: FontWeight.w900,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
          actions: [SmartSpeechToText(), LanguagePicker()],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 20,
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Welcome ${_currentUser.displayName?.split(' ')[0]}.",
                    style: TextStyle().copyWith(
                      color: darkGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "How may we help you today?",
                    style: TextStyle().copyWith(
                      color: darkGrey,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30),
              Container(
                height: 220,
                margin: EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onTap: () => _showDialog(context: context),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          "assets/images/report_case.png",
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black,
                                Color(0xFF1E1E1E).withOpacity(.36)
                              ],
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Text(
                                _language.reportACase,
                                style: TextStyle().copyWith(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 220,
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      height: 220,
                      margin: EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pushNamed("/srhr"),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                "assets/images/period_tracker_image.png",
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.0),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black,
                                      Color(0xFF1E1E1E).withOpacity(.36)
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      _language.allAboutSRHR,
                                      style: TextStyle().copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                    Expanded(
                        child: Container(
                      height: 220,
                      margin: EdgeInsets.only(left: 6),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => ImpactOfSmartRR())),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                "assets/images/report_case.png",
                                fit: BoxFit.cover,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.black,
                                      Color(0xFF1E1E1E).withOpacity(.36)
                                    ],
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(18.0),
                                    child: Text(
                                      _language.impactOfSmartRR,
                                      style: TextStyle().copyWith(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          foregroundColor: Colors.white,
          child: Text("SOS"),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ChatBot(),
            ),
          ),
        ),
      ),
    );
  }

  _showDialog({required BuildContext context}) {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    child: Text(
                      S.current.yourself,
                      style: TextStyle().copyWith(color: materialWhite),
                    ),
                    onTap: () => _onReportTap(userType: true),
                  ),
                  Divider(),
                  InkWell(
                    child: Text(
                      S.current.someoneElse,
                      style: TextStyle().copyWith(color: materialWhite),
                    ),
                    onTap: () => _onReportTap(userType: false),
                  )
                ],
              ),
            ),
          );
        });
  }

  _onReportTap({required bool userType}) async {
    Navigator.pop(context);
    await setUserTypePref(userType: userType).then((_) {
      _showConsent();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (BuildContext context) => ConsentFormPage(),
      //   ),
      // );
    });
  }

  _showConsent() {
    bool acceptedValue = false;

    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      context: context,
      builder: (context) => ConsentFormPage(),
    );
  }
}
