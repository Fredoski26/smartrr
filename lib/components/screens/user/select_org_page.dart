import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:smartrr/components/widgets/show_action.dart';
import 'package:smartrr/components/widgets/show_loading.dart';
import 'package:smartrr/utils/colors.dart';
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

  const SelectOrgPage({
    Key key,
    @required this.service,
    @required this.selectedState,
    @required this.selectedLocation,
    @required this.isUser,
    @required this.referredBy,
    @required this.referredName,
    @required this.caseId,
  }) : super(key: key);

  @override
  _SelectOrgPageState createState() => _SelectOrgPageState();
}

class _SelectOrgPageState extends State<SelectOrgPage> {
  bool acceptedValue = false;
  List<Organization> serviceProviderList = new List<Organization>();
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
            FlatButton(
              onPressed: () => Navigator.pop(context),
              child: Text('No'),
            ),
            FlatButton(
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
      body: Container(
        width: MediaQuery.of(context).size.width,
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
                    "${widget.selectedLocation.title}, ${widget.selectedState.title}",
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
                    'Select Organization',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
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
                                    color: Color(0xFFFCF200),
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                              ),
                            )
                          : Expanded(
                              child: ListView.builder(
                                itemCount: serviceProviderList.length,
                                itemBuilder: (context, index) {
                                  String location = '';
                                  if (serviceProviderList[index]
                                      .lga
                                      .isNotEmpty) {
                                    location = serviceProviderList[index].lga;
                                  } else if (serviceProviderList[index]
                                      .site
                                      .isNotEmpty) {
                                    location = serviceProviderList[index].site;
                                  } else if (serviceProviderList[index]
                                      .ward
                                      .isNotEmpty) {
                                    location = serviceProviderList[index].ward;
                                  } else {
                                    location = widget.selectedLocation.title;
                                  }
                                  return BlackLocationCell(
                                      width: MediaQuery.of(context).size.width *
                                          0.9,
                                      textColor: Colors.white,
                                      bgColor: Color(0x77000000),
                                      child: Column(
                                        children: <Widget>[
                                          Text(
                                            serviceProviderList[index].name,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Color(0xFFF7EC03),
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

  _getDataFromFirebase() {
    FirebaseFirestore.instance
        .collection("organizations")
        .where('locationId', isEqualTo: widget.selectedLocation.id)
        .get()
        .then((organizations) {
      for (int i = 0; i < organizations.docs.length; i++) {
        Organization organization = new Organization(
          id: organizations.docs[i].id,
          name: organizations.docs[i].get('name'),
          locationId: organizations.docs[i].get('locationId'),
          status: organizations.docs[i].get('status'),
          ward: organizations.docs[i].get('ward'),
          site: organizations.docs[i].get('site'),
          lga: organizations.docs[i].get('lga'),
          criteria: organizations.docs[i].get('criteria'),
          comments: organizations.docs[i].get('comments'),
          closeTime: organizations.docs[i].get('closeTime'),
          endDate: organizations.docs[i].get('endDate'),
          focalDesignation: organizations.docs[i].get('focalDesignation'),
          focalEmail: organizations.docs[i].get('focalEmail'),
          focalName: organizations.docs[i].get('focalName'),
          focalPhone: organizations.docs[i].get('focalPhone'),
          how: organizations.docs[i].get('how'),
          language: organizations.docs[i].get('language'),
          orgEmail: organizations.docs[i].get('orgEmail'),
          password: organizations.docs[i].get('password'),
          servicesAvailable:
              organizations.docs[i].get('servicesAvailable'),
          startDate: organizations.docs[i].get('startDate'),
          startTime: organizations.docs[i].get('startTime'),
          telephone: organizations.docs[i].get('telephone'),
          type: organizations.docs[i].get('type'),
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
      setState(() => isLoading = false);
    });
  }

  _onRefer(Organization org) {
    Navigator.pop(context);
    showLoading(message: 'Referring to ${org.name}', context: context);
    try {
      FirebaseFirestore.instance
          .collection('cases')
          .doc(widget.caseId)
          .update({
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
