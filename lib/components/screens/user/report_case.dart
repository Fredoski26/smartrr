import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartrr/components/screens/user/select_org_page.dart';
import 'package:smartrr/components/widgets/smart_dropdown.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/models/location.dart';
import 'package:smartrr/models/smart_service.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:smartrr/services/database_service.dart';
import 'package:smartrr/services/theme_provider.dart';
import 'package:smartrr/utils/colors.dart';

class ReportCase extends StatefulWidget {
  final String lang;
  final bool isUser;
  const ReportCase({super.key, this.isUser = true, this.lang = "en"});

  @override
  State<ReportCase> createState() => _ReportCaseState();
}

class _ReportCaseState extends State<ReportCase> {
  late DatabaseService _databaseService;
  late dynamic _userData;

  bool isLoading = true;
  dynamic error = null;
  List<SmartService> serviceList = [];
  List<SmartService> subServiceList = [];
  List statesList = <Map<String, dynamic>>[];
  List lgaList = <Map<String, dynamic>>[];

  List<DropdownMenuItem<SmartService>> _serviceDropdownMenuItems = [];
  List<DropdownMenuItem<String>> _lgaDropdownMenuItems = [];

  SmartService? service = null;
  SmartService? subService = null;
  Map<String, dynamic>? state = null;
  String? lga = null;

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, theme, _) => Scaffold(
        appBar: AppBar(
          title: Text(
            S.current.reportACase,
            style: TextStyle(color: darkGrey),
          ),
        ),
        backgroundColor: Color(0xFFEEEEEE),
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : error != null
                  ? Center(
                      child: Text(error),
                    )
                  : Form(
                      child: ListView(
                        children: [
                          SmartFormDropDown(
                            value: service,
                            items: _serviceDropdownMenuItems,
                            hintText: "Case Type",
                            onChanged: (selectedService) {
                              setState(() => service = selectedService);
                              _getSubServices(selectedService!.id);
                            },
                          ),
                          SmartFormDropDown(
                            value: subService,
                            items: subServiceList
                                .map(
                                  (service) => DropdownMenuItem(
                                      child: Text(service.name.split('_')[1]),
                                      value: service),
                                )
                                .toList(),
                            hintText: "Subcase Type",
                            onChanged: (selectedSubService) {
                              setState(() => subService = selectedSubService);
                              _getStates();
                            },
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: SmartFormDropDown(
                                  value: state,
                                  items: statesList
                                      .map((state) => DropdownMenuItem(
                                            child: Text(state["name"]),
                                            value: state,
                                          ))
                                      .toList(),
                                  hintText: "State",
                                  onChanged: (selectedState) {
                                    setState(() => state = selectedState);
                                    _getCities(selectedState["name"]);
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: SmartFormDropDown(
                                  value: lga,
                                  items: _lgaDropdownMenuItems,
                                  hintText: "LGA",
                                  onChanged: (value) {
                                    setState(() {
                                      lga = value;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextButton(
                              onPressed: state != null &&
                                      lga != null &&
                                      service != null &&
                                      subService != null
                                  ? () {
                                      print(subService?.name.split("_")[1]);
                                      print(service?.name);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              SelectOrgPage(
                                            service:
                                                subService!.name.split('_')[1],
                                            selectedState: MyLocation(
                                                state!["name"], state!["name"]),
                                            selectedLocation:
                                                MyLocation(lga!, lga!),
                                            isUser: widget.isUser,
                                            referredBy: "",
                                            referredName: "",
                                            caseId: "",
                                          ),
                                        ),
                                      );
                                    }
                                  : null,
                              child: Text("Continue"))
                        ],
                      ),
                    ),
        ),
      ),
    );
  }

  Future _getServices() async {
    final services = await _databaseService.getServices(widget.lang);
    setState(() {
      service = null;
      serviceList = services;
      _serviceDropdownMenuItems = buildServiceDropDownItems(services);
      isLoading = false;
    });
  }

  Future _getSubServices(String serviceId) async {
    final subServices =
        await _databaseService.getSubServices(serviceId, widget.lang);
    setState(() {
      subService = null;
      subServiceList = subServices;
      isLoading = false;
    });
  }

  Future _getStates() async {
    _userData = await DatabaseService().getUser();
    final states = await CountryService.getStates(_userData["country"]);
    setState(() {
      state = null;
      statesList = states;
      isLoading = false;
    });
  }

  Future _getCities(String state) async {
    final lgas = await CountryService.getCities(_userData["country"], state);
    setState(() {
      lga = null;
      lgaList = lgas;
      _lgaDropdownMenuItems = buildLGADropDownItems(lgas);
      isLoading = false;
    });
  }

  List<DropdownMenuItem<String>> buildLGADropDownItems(List<dynamic> list) {
    List<DropdownMenuItem<String>> items = [];
    for (dynamic location in list) {
      items.add(
        DropdownMenuItem(
          value: location,
          child: Text(location),
        ),
      );
    }
    return items;
  }

  List<DropdownMenuItem<SmartService>> buildServiceDropDownItems(
      List<SmartService> list) {
    List<DropdownMenuItem<SmartService>> items = [];
    for (SmartService location in list) {
      items.add(
        DropdownMenuItem(
          value: location,
          child: Text(location.name),
        ),
      );
    }
    return items;
  }

  @override
  void initState() {
    _databaseService = DatabaseService();
    _getServices();
    super.initState();
  }
}
