import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/my_stepper.dart';
import '../../../models/location.dart';
import 'select_state_page.dart';
import '../../widgets/circular_progress.dart';

class SelectSubServicePage extends StatefulWidget {
  final MyLocation selectedService;

  const SelectSubServicePage({Key key, this.selectedService}) : super(key: key);

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
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SelectStatePage(
                                    service: subServiceList[index].title,
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
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                Radius.circular(12),
                              )),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  child: Text(
                                    subServiceList[index].title,
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
      for (int i = 0; i < subServices.docs.length; i++) {
        debugPrint(
            "iiiiiii: ${subServices.docs[i].get('title').toString()}  ::  " +
                subServices.docs[i].id);
        setState(() => subServiceList.add(MyLocation(
            subServices.docs[i].id.toString(),
            subServices.docs[i].get('title'))));
      }
      setState(() => isLoading = false);
    });
  }
}
