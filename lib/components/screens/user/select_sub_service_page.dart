import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/my_stepper.dart';
import 'package:smartrr/services/my_translator.dart';
import 'package:smartrr/utils/colors.dart';
import '../../../models/location.dart';
import 'select_state_page.dart';
import '../../widgets/circular_progress.dart';

class SelectSubServicePage extends StatefulWidget {
  final MyLocation selectedService;
  final bool isDarkTheme;
  final String lang;

  const SelectSubServicePage(
      {Key key, this.selectedService, this.isDarkTheme, this.lang = "en"})
      : super(key: key);

  @override
  _SelectSubServicePageState createState() => _SelectSubServicePageState();
}

class _SelectSubServicePageState extends State<SelectSubServicePage> {
  bool acceptedValue = false;
  List<MyLocation> subServiceList = <MyLocation>[];
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
        title: Text(widget.selectedService.title),
      ),
      body: Container(
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
                  MyStepper(activeIndex: 1),
                  SizedBox(height: 31),
                  Expanded(
                    child: ListView.builder(
                      itemCount: subServiceList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SelectStatePage(
                                    lang: widget.lang,
                                    isDarkTheme: widget.isDarkTheme,
                                    service: subServiceList[index]
                                        .title
                                        .split("_")[1],
                                    isUser: true,
                                    referredName: '',
                                    referredBy: '',
                                    caseId: '',
                                  ),
                                ),
                              );
                            },
                            child: Card(
                              elevation: 8,
                              color:
                                  widget.isDarkTheme ? lightGrey : Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              )),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Text(
                                    subServiceList[index].title.split("_")[0],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
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
      ),
    );
  }

  _getDataFromFirebase() {
    FirebaseFirestore.instance
        .collection("services")
        .doc(widget.selectedService.id)
        .collection("sub-services")
        .get()
        .then((subServices) {
      subServices.docs.forEach((subService) async {
        final String originaName = subService.get("title");

        if (widget.lang == "ha") {
          final translation = await MyTranslator.translate(text: originaName);

          setState(() => subServiceList
              .add(MyLocation(subService.id, "${translation}_${originaName}")));
        } else {
          setState(() => subServiceList.add(MyLocation(
              subService.id, "${subService.get("title")}_${originaName}")));
        }
      });
    }).then((value) => setState(() => isLoading = false));
  }
}
