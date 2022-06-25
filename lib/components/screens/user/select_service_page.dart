import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/widgets/my_stepper.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/services/my_translator.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';
import '../../../models/location.dart';
import 'select_sub_service_page.dart';
import '../../widgets/circular_progress.dart';

class SelectServicePage extends StatefulWidget {
  final String lang;
  final bool isUser;
  final String referredBy;
  final String referredName;
  final String caseId;
  final bool isDarkTheme;

  SelectServicePage({
    this.lang = "en",
    this.isUser = true,
    this.referredBy = "",
    this.referredName = "",
    this.caseId = "",
    this.isDarkTheme = false,
  });
  @override
  _SelectServicePageState createState() => _SelectServicePageState();
}

class _SelectServicePageState extends State<SelectServicePage> {
  bool acceptedValue = false;
  List<MyLocation> serviceList = <MyLocation>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectService),
      ),
      body: Consumer<ThemeNotifier>(
          builder: ((context, notifier, child) => Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 25, vertical: 4),
                decoration: BoxDecoration(),
                child: isLoading
                    ? Center(
                        child: CircularProgress(),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyStepper(),
                          SizedBox(height: 31),
                          Expanded(
                            child: ListView.builder(
                              itemCount: serviceList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SelectSubServicePage(
                                            isUser: widget.isUser,
                                            referredBy: widget.referredBy,
                                            referredName: widget.referredName,
                                            caseId: widget.caseId,
                                            lang: widget.lang,
                                            isDarkTheme: notifier.darkTheme,
                                            selectedService: serviceList[index],
                                          ),
                                        ),
                                      );
                                    },
                                    child: Card(
                                      elevation: 8,
                                      color: notifier.darkTheme
                                          ? lightGrey
                                          : Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      )),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 12),
                                          child: Text(
                                            serviceList[index].title,
                                            style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
              ))),
    );
  }

  _getDataFromFirebase() {
    FirebaseFirestore.instance.collection('services').get().then((docs) {
      docs.docs.forEach((service) async {
        if (widget.lang == "ha") {
          final translation =
              await MyTranslator.translate(text: service.get("title"));

          setState(() => serviceList.add(MyLocation(service.id, translation)));
        } else {
          setState(() =>
              serviceList.add(MyLocation(service.id, service.get("title"))));
        }
      });
    }).then((value) => setState(() => isLoading = false));
  }
}
