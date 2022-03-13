import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartrr/components/widgets/my_stepper.dart';
import '../../widgets/circular_progress.dart';
import '../../widgets/location_cell.dart';
import '../../../models/location.dart';
import 'select_org_page.dart';

class SelectLocationPage extends StatefulWidget {
  final String service;
  final MyLocation selectedState;
  final bool isUser;
  final String referredBy;
  final String referredName;
  final String caseId;

  const SelectLocationPage({
    Key key,
    @required this.service,
    @required this.selectedState,
    @required this.isUser,
    @required this.referredBy,
    @required this.referredName,
    @required this.caseId,
  }) : super(key: key);

  @override
  _SelectLocationPageState createState() => _SelectLocationPageState();
}

class _SelectLocationPageState extends State<SelectLocationPage> {
  bool acceptedValue = false;
  String currentSelectedAddress = '';
  List<MyLocation> locationList = <MyLocation>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  locationSelected(MyLocation locationSelected) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => SelectOrgPage(
          service: widget.service,
          selectedState: widget.selectedState,
          selectedLocation: locationSelected,
          isUser: widget.isUser,
          referredBy: widget.referredBy,
          referredName: widget.referredName,
          caseId: widget.caseId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Select LGA")),
      body: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        child: isLoading
            ? Center(
                child: CircularProgress(),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyStepper(activeIndex: 3),
                  SizedBox(height: 31),
                  Expanded(
                    child: ListView.builder(
                      itemCount: locationList.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: LocationCell(
                            width: MediaQuery.of(context).size.width * 1,
                            title: locationList[index].title,
                            borderRadius: 10,
                            func: () {
                              locationSelected(locationList[index]);
                            },
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
    CollectionReference stateCollection =
        FirebaseFirestore.instance.collection("state");

    stateCollection
        .where("sName", isEqualTo: widget.selectedState.title)
        .get()
        .then((states) {
      if (states.docs.length > 0) {
        final stateId = states.docs[0].id;

        stateCollection
            .doc(stateId)
            .collection("locations")
            .get()
            .then((locations) {
          for (int i = 0; i < locations.docs.length; i++) {
            locationList.add(MyLocation(locations.docs[i].id.toString(),
                locations.docs[i].get('location')));
          }
          setState(() => isLoading = false);
        });
      } else {
        throw "No locations found";
      }
    }).catchError((e) {
      Navigator.pop(context);
      Fluttertoast.showToast(
        msg: e.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black.withOpacity(.5),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });

    // FirebaseFirestore.instance
    //     .collection("state")
    //     .doc(widget.selectedState.id)
    //     .collection("locations")
    //     .get()
    //     .then((locations) {
    //   for (int i = 0; i < locations.docs.length; i++) {
    //     debugPrint(
    //         "iiiiiii: ${locations.docs[i].get('location').toString()}  ::  " +
    //             locations.docs[i].id);
    //     setState(() => locationList.add(MyLocation(
    //         locations.docs[i].id.toString(),
    //         locations.docs[i].get('location'))));
    //   }
    //   setState(() => isLoading = false);
    // });
  }
}
