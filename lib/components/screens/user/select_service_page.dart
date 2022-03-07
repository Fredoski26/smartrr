import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/my_stepper.dart';
import '../../../models/location.dart';
import 'select_sub_service_page.dart';
import '../../widgets/circular_progress.dart';

class SelectServicePage extends StatefulWidget {
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
        title: Text("Select Service Type"),
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
                  MyStepper(),
                  SizedBox(height: 31),
                  Expanded(
                    child: ListView.builder(
                      itemCount: serviceList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      SelectSubServicePage(
                                    selectedService: serviceList[index],
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
      ),
    );
  }

  _getDataFromFirebase() {
    FirebaseFirestore.instance.collection('services').get().then((docs) {
      for (int i = 0; i < docs.docs.length; i++) {
        debugPrint(
            "${docs.docs[i].get('title').toString()}  ::  " + docs.docs[i].id);
        setState(() => serviceList.add(
            MyLocation(docs.docs[i].id.toString(), docs.docs[i].get('title'))));
      }
      setState(() => isLoading = false);
    });
  }
}
