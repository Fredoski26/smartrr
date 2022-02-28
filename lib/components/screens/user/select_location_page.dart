import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/utils/colors.dart';
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
  List<MyLocation> locationList = new List<MyLocation>();
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
        builder: (BuildContext context) =>
            SelectOrgPage(
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
      body: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 4),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: isLoading
            ? Center(
          child: CircularProgress(),
              )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                  SizedBox(
                    height: kToolbarHeight + 10,
                  ),
                  Text(
                    widget.selectedState.title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: smartYellow,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            Text(
              'Select Location',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: locationList.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: LocationCell(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 1,
                      textColor: Colors.white,
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
    FirebaseFirestore.instance
        .collection("state")
        .doc(widget.selectedState.id)
        .collection("locations")
        .get()
        .then((locations) {
      for (int i = 0; i < locations.docs.length; i++) {
        debugPrint(
            "iiiiiii: ${locations.docs[i].get('location').toString()}  ::  " +
                locations.docs[i].id);
        setState(() => locationList.add(MyLocation(
            locations.docs[i].id.toString(),
            locations.docs[i].get('location'))));
      }
      setState(() => isLoading = false);
    });
  }
}
