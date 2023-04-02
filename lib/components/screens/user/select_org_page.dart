import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/show_loading.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/utils/colors.dart';
import 'package:smartrr/utils/utils.dart';
import '../../widgets/selected_location_cell.dart';
import '../../../models/location.dart';
import '../../../models/organization.dart';
import 'case_description_page.dart';
import '../../widgets/circular_progress.dart';

class SelectOrgPage extends StatefulWidget {
  final String service;
  final MyLocation selectedState;
  final MyLocation selectedLocation;
  final bool isUser;
  final String referredBy;
  final String referredName;
  final String caseId;
  final String lang;

  const SelectOrgPage({
    super.key,
    required this.service,
    required this.selectedState,
    required this.selectedLocation,
    required this.isUser,
    required this.referredBy,
    required this.referredName,
    required this.caseId,
    this.lang = "en",
  });

  @override
  _SelectOrgPageState createState() => _SelectOrgPageState();
}

class _SelectOrgPageState extends State<SelectOrgPage> {
  bool acceptedValue = false;
  List<Organization> serviceProviderList = <Organization>[];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDataFromFirebase();
  }

  serviceProviderSelected(Organization org) {
    if (widget.isUser) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => CaseDescriptionPage(
            service: widget.service,
            location: widget.selectedLocation,
            state: widget.selectedState,
            org: org,
          ),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          elevation: 30,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(
            'Do you want to refer to ${org.name}',
            style: TextStyle(
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => _onRefer(org),
              child: Text('Yes'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).selectServiceProvider,
          style: TextStyle().copyWith(color: darkGrey),
        ),
      ),
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
                  Text(
                    "Location: ${widget.selectedLocation.title}, ${widget.selectedState.title}",
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 20),
                  isLoading
                      ? Center(
                          child: CircularProgress(),
                        )
                      : serviceProviderList.length == 0
                          ? Center(
                              child: Text(
                                'No Organizations Found',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: serviceProviderList.length,
                                itemBuilder: (context, index) {
                                  String location = '';

                                  location = widget.selectedLocation.title;
                                  return BlackLocationCell(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      textColor: Colors.white,
                                      bgColor: primaryColor,
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            serviceProviderList[index].name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            location,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            serviceProviderList[index]
                                                .telephone,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          Text(
                                            serviceProviderList[index].orgEmail,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          )
                                        ],
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                      ),
                                      borderRadius: 10,
                                      func: () {
                                        serviceProviderSelected(
                                          serviceProviderList[index],
                                        );
                                      });
                                },
                              ),
                            )
                ],
              ),
      ),
    );
  }

  _getDataFromFirebase() async {
    try {
      await FirebaseFirestore.instance
          .collectionGroup("locations")
          .where("location", isEqualTo: widget.selectedLocation.title)
          .get()
          .then((snapshot) async {
        List<QueryDocumentSnapshot<Map<String, dynamic>>> organizations = [];

        if (snapshot.docs.isNotEmpty) {
          await FirebaseFirestore.instance
              .collection("organizations")
              .where("locationId", isEqualTo: snapshot.docs[0].id)
              .get()
              .then((orgs) async {
            organizations = [...organizations, ...orgs.docs];
          });
        }

        await FirebaseFirestore.instance
            .collection("organizations")
            .where('location', isEqualTo: widget.selectedLocation.title)
            .get()
            .then((orgsByLocationName) {
          organizations = [...organizations, ...orgsByLocationName.docs];
        });
        _addOrgsToList(organizations);
      });
    } catch (e, stackTrace) {
      showToast(msg: e.toString(), type: "error");
      await Sentry.captureException(e, stackTrace: stackTrace);
    } finally {
      setState(() => isLoading = false);
    }
  }

  _addOrgsToList(
      List<QueryDocumentSnapshot<Map<String, dynamic>>> organizations) {
    for (int i = 0; i < organizations.length; i++) {
      Organization organization = new Organization(
        id: organizations[i].id,
        name: organizations[i].get('name'),
        locationId: organizations[i].get('locationId'),
        location: organizations[i].data().containsKey("location")
            ? organizations[i].get("location")
            : "",
        status: organizations[i].get('status'),
        closeTime: organizations[i].get('closeTime'),
        focalDesignation: organizations[i].get('focalDesignation'),
        focalEmail: organizations[i].get('focalEmail'),
        focalName: organizations[i].get('focalName'),
        focalPhone: organizations[i].get('focalPhone'),
        language: organizations[i].get('language'),
        orgEmail: organizations[i].get('orgEmail'),
        password: organizations[i].get('password'),
        servicesAvailable: organizations[i].get('servicesAvailable'),
        startTime: organizations[i].get('startTime'),
        telephone: organizations[i].get('telephone'),
        type: organizations[i].get('type'),
      );
      if (organization.servicesAvailable != null) {
        for (int j = 0; j < organization.servicesAvailable.length; j++) {
          if (widget.service.toLowerCase().trim().contains(organization
              .servicesAvailable[j]
              .toString()
              .toLowerCase()
              .trim())) {
            setState(() => serviceProviderList.add(organization));
          }
        }
      }
    }
  }

  _onRefer(Organization org) {
    Navigator.pop(context);
    showLoading(message: 'Referring to ${org.name}', context: context);
    try {
      FirebaseFirestore.instance.collection('cases').doc(widget.caseId).update({
        'orgId': org.id,
        'orgName': org.name,
        'orgEmail': org.orgEmail,
        'focalPhone': org.focalPhone,
        'referredBy': widget.referredBy,
        'referredByName': widget.referredName,
      }).then((onValue) {
        Navigator.pop(context);
        showAction(
          actionText: 'OK',
          text: 'Case Referred Successfully!',
          func: _caseReferred,
          context: context,
        );
      });
    } catch (error) {
      Navigator.pop(context);
      showAction(
        actionText: 'OK',
        text: 'Case Referred Failed!',
        func: () => Navigator.pop(context),
        context: context,
      );
    }
  }

  _caseReferred() {
    Navigator.pushNamedAndRemoveUntil(
        context, '/orgMain', ModalRoute.withName('Dashboard'));
  }
}
