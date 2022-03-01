import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smartrr/utils/colors.dart';
import '../../widgets/location_cell.dart';
import '../../../models/location.dart';
import 'select_location_map.dart';
import 'select_location_page.dart';
import 'select_org_page.dart';
import '../../widgets/circular_progress.dart';

class SelectStatePage extends StatefulWidget {
  final String service;
  final bool isUser;
  final String referredBy;
  final String referredName;
  final String caseId;

  const SelectStatePage({
    Key key,
    @required this.service,
    @required this.isUser,
    @required this.referredBy,
    @required this.referredName,
    @required this.caseId,
  }) : super(key: key);

  @override
  _SelectStatePageState createState() => _SelectStatePageState();
}

class _SelectStatePageState extends State<SelectStatePage> {
  bool acceptedValue = false;
  String currentSelectedAddress = '';
  List<MyLocation> stateList = new List<MyLocation>();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  locationSelected(MyLocation stateSelected) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) =>
            SelectLocationPage(
              selectedState: stateSelected,
              service: widget.service,
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
                    widget.service,
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
              'Select State',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: stateList.length,
                itemBuilder: (context, index) {
                        if (index == stateList.length - 1) {
                          return Column(
                            children: <Widget>[
                              LocationCell(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 1,
                                textColor: Colors.white,
                                title: stateList[index].title,
                                borderRadius: 10,
                                func: () {
                                  locationSelected(stateList[index]);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              LocationCell(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 1,
                                textColor: Colors.white,
                                title: currentSelectedAddress == ''
                                    ? 'Select Custom Location'
                                    : currentSelectedAddress,
                                borderRadius: 10,
                                func: () async {
                                  if (currentSelectedAddress == '') {
                                    String selectedAddress =
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder:
                                                (BuildContext context) =>
                                                SelectLocationMap()));
                                    setState(() {
                                      if (selectedAddress != null)
                                        currentSelectedAddress =
                                        '$selectedAddress';
                                    });
                                  } else {
                                    setState(() => isLoading = true);
                                    bool _isFound = true;
                                    MyLocation myLocation;
                                    MyLocation myState;
                                    for (int i = 0; i < stateList.length; i++) {
                                      if (currentSelectedAddress
                                          .toLowerCase()
                                          .contains(stateList[index]
                                          .title
                                          .toLowerCase())) {
                                        debugPrint('I FOUND THE STATE');
                                        myState = new MyLocation(
                                            stateList[index].id,
                                            stateList[index].title);
                                        await FirebaseFirestore.instance
                                            .collection("state")
                                            .doc(stateList[index].id)
                                            .collection("locations")
                                            .get()
                                            .then((locations) {
                                          for (int j = 0;
                                          j < locations.docs.length;
                                          j++) {
                                            debugPrint(
                                                "iiiiiii: ${locations
                                                    .docs[j]
                                                    .get('location')
                                                    .toString()}  ::  " +
                                                    locations.docs[j]
                                                        .id);
                                            if (currentSelectedAddress
                                                .toLowerCase()
                                                .contains(locations.docs[j]
                                                .get('location')
                                                .toLowerCase())) {
                                              debugPrint('I FOUND THE CITY');
                                              _isFound = true;
                                              myLocation = new MyLocation(
                                                  locations
                                                      .docs[j].id
                                                      .toString(),
                                                  locations.docs[j]
                                                      .get('location'));
                                              return;
                                            } else {
                                              _isFound = false;
                                              debugPrint('City not foun');
                                            }
                                          }
                                        });
                                      } else {
                                        debugPrint('State not foun');
                                        _isFound = false;
                                      }
                                    }
                                    setState(() => isLoading = false);
                                    if (_isFound) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SelectOrgPage(
                                                service: widget.service,
                                                selectedState: myState,
                                                selectedLocation: myLocation,
                                              ),
                                        ),
                                      );
                                    } else {
                                      Fluttertoast.showToast(
                                          msg: "Area not found",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.black54.withOpacity(0.3),
                                          textColor: Colors.white,
                                          fontSize: 16.0);
                                    }
                                  }
                                },
                              ),
                            ],
                          );
                        } else {
                          return Column(
                            children: <Widget>[
                              LocationCell(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 1,
                                textColor: Colors.white,
                                title: stateList[index].title,
                                borderRadius: 10,
                                func: () {
                                  locationSelected(stateList[index]);
                                },
                              ),
                              SizedBox(
                                height: 10,
                              )
                            ],
                          );
                        }
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }

  _getDataFromFirebase() {
    FirebaseFirestore.instance.collection('state').get().then((docs) {
      for (int i = 0; i < docs.docs.length; i++) {
        debugPrint("${docs.docs[i].get('sName').toString()}  ::  " +
            docs.docs[i].id);
        setState(() => stateList.add(MyLocation(
            docs.docs[i].id.toString(),
            docs.docs[i].get('sName'))));
      }
      setState(() => isLoading = false);
    });
  }
}