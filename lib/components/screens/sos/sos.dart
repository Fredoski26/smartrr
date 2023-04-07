import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smartrr/components/widgets/smart_dropdown.dart';
import 'package:smartrr/services/api_client.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:smartrr/services/database_service.dart';

class SOS extends StatefulWidget {
  const SOS({super.key});

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  bool isLoading = true;
  late Map<String, dynamic>? selectedState = null;
  List statesList = <Map<String, dynamic>>[];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: SmartFormDropDown(
                        value: selectedState,
                        items: statesList
                            .map((state) => DropdownMenuItem(
                                  child: Text(state["name"]),
                                  value: state,
                                ))
                            .toList(),
                        hintText: "Select state",
                        onChanged: (value) {
                          setState(() => selectedState = value);
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          _submitSos();
                        },
                        child: Text("Alert"),
                      ),
                    )
                  ],
                )
              ],
            ),
    );
  }

  Future _getStates() async {
    return DatabaseService().getUser().then((user) async {
      await CountryService.getStates(user["country"]).then((states) {
        statesList = states;
        isLoading = false;
        setState(() => {});
      });
    });
  }

  _submitSos() async {
    final file =
        await rootBundle.loadString("assets/state-emergency-lines.json");

    final List jsonFile = jsonDecode(file);

    final match =
        jsonFile.where((state) => state["state"] == selectedState?["name"]);

    if (match.isNotEmpty) {
      setState(() => isLoading = true);

      final location = new Location();
      final currentLocation = await location.getLocation();
      final currentLocationName = await ApiClient().getAddressFromCoordinates(
        currentLocation.latitude!,
        currentLocation.longitude!,
      );
      final message =
          "SOS from SmartRR App!\nI need help!\nLocation: ${currentLocationName}";
      print(message);
      await ApiClient().sendSMS(
        phoneNumber: match.first["emergency_lines"],
        message: message,
      );
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    _getStates();
    super.initState();
  }
}
