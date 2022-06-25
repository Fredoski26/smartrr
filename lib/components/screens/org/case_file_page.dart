import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/select_service_page.dart';
import 'package:smartrr/components/screens/user/select_state_page.dart';
import 'package:smartrr/models/case.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';

class CaseFilePage extends StatefulWidget {
  final Case caseFile;

  const CaseFilePage({Key key, @required this.caseFile}) : super(key: key);

  @override
  _CaseFilePageState createState() => _CaseFilePageState();
}

class _CaseFilePageState extends State<CaseFilePage> {
  bool acceptedValue = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
        builder: (context, ThemeNotifier themeNotifier, child) => Scaffold(
              appBar: AppBar(title: Text("Case File")),
              body: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.caseFile.caseDesc,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    texts(
                      title: 'Case Type',
                      value: widget.caseFile.caseType,
                    ),
                    texts(
                      title: 'Location',
                      value: widget.caseFile.locationName,
                    ),
                    texts(
                      title: 'Current Organization',
                      value: widget.caseFile.orgName,
                    ),
                  ],
                ),
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => SelectServicePage(
                              isDarkTheme: themeNotifier.darkTheme,
                              isUser: false,
                              referredBy: widget.caseFile.orgId,
                              referredName: widget.caseFile.orgName,
                              caseId: widget.caseFile.id,
                            )),
                  );
                },
                label: Text(
                  'Refer',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                backgroundColor: primaryColor,
              ),
            ));
  }
}
