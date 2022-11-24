import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/impact_of_smartrr.dart';
import 'package:smartrr/components/widgets/chatbot.dart';
import 'package:smartrr/components/widgets/language_picker.dart';
import 'package:smartrr/components/widgets/speech_to_text.dart';
import 'package:smartrr/provider/language_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import 'consent_form_page.dart';
import '../../widgets/custom_drawer.dart';
import 'package:smartrr/generated/l10n.dart';

class ReportOrHistoryPage extends StatefulWidget {
  @override
  _ReportOrHistoryPageState createState() => _ReportOrHistoryPageState();
}

class _ReportOrHistoryPageState extends State<ReportOrHistoryPage> {
  final mScaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Consumer<LanguageNotifier>(
        builder: (context, _, child) => Scaffold(
              key: mScaffoldState,
              drawer: CustomDrawer(),
              appBar: AppBar(
                title: Text("Smart RR"),
                actions: [SmartSpeechToText(), LanguagePicker()],
              ),
              body: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 60.0, vertical: 70.0),
                  child: Column(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () => _bottomSheet(context: context),
                        child: Container(
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10))),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.input),
                                Text(
                                  _language.reportACase,
                                  style: TextStyle().copyWith(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ],
                            ))),
                      )),
                      Expanded(
                        child: Container(
                          child: Row(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                onTap: () =>
                                    Navigator.of(context).pushNamed("/srhr"),
                                child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    margin: EdgeInsets.only(right: 2.5),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10),
                                        )),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.info_outline_rounded),
                                        Text(
                                          _language.allAboutSRHR,
                                          style: TextStyle().copyWith(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ))),
                              )),
                              Expanded(
                                  child: GestureDetector(
                                onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ImpactOfSmartRR())),
                                child: Container(
                                    padding: EdgeInsets.all(5.0),
                                    margin: EdgeInsets.only(left: 2.5),
                                    decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius: BorderRadius.only(
                                            bottomRight: Radius.circular(10))),
                                    child: Center(
                                        child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.public),
                                        Text(
                                          _language.impactOfSmartRR,
                                          textAlign: TextAlign.center,
                                          style: TextStyle().copyWith(
                                              color: Colors.white,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ))),
                              )),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                  // Center(
                  //   child: IntrinsicWidth(
                  //     child: Column(
                  //       crossAxisAlignment: CrossAxisAlignment.stretch,
                  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  //       children: [
                  //         ElevatedButton.icon(
                  //           onPressed: () => _bottomSheet(context: context),
                  //           icon: Icon(Icons.input),
                  //           label: Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 0, vertical: 20.0),
                  //             child: Text(_language.reportACase),
                  //           ),
                  //         ),
                  //         ElevatedButton.icon(
                  //           onPressed: () =>
                  //               Navigator.of(context).pushNamed("/srhr"),
                  //           icon: Icon(Icons.info_rounded),
                  //           label: Padding(
                  //             padding: const EdgeInsets.symmetric(
                  //                 horizontal: 0, vertical: 20.0),
                  //             child: Text(_language.allAboutSRHR),
                  //           ),
                  //         ),
                  //         ElevatedButton.icon(
                  //             onPressed: () => Navigator.of(context).push(
                  //                 MaterialPageRoute(
                  //                     builder: (context) => ImpactOfSmartRR())),
                  //             icon: Icon(Icons.public),
                  //             label: Padding(
                  //               padding: const EdgeInsets.symmetric(
                  //                   horizontal: 0, vertical: 20.0),
                  //               child: Text(_language.impactOfSmartRR),
                  //             )),
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  ),
              floatingActionButton: FloatingActionButton(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  child: Icon(Icons.chat),
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => ChatBot()))),
            ));
  }

  _bottomSheet({BuildContext context}) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        context: context,
        builder: (context) {
          return Container(
            height: 250,
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      S.current.reportFor,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(S.current.yourself),
                        onPressed: () => _onReportTap(userType: true),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        child: Text(S.current.someoneElse),
                        onPressed: () => _onReportTap(userType: false),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  _onReportTap({bool userType}) async {
    Navigator.pop(context);
    await setUserTypePref(userType: userType).then((_) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => ConsentFormPage(),
        ),
      );
    });
  }
}
