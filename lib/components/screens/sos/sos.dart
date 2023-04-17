import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:smartrr/components/widgets/smart_dropdown.dart';
import 'package:smartrr/services/api_client.dart';
import 'package:smartrr/utils/utils.dart';

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
                                  child: Text(state["state"]),
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
                        onPressed: selectedState != null ? _submitSos : null,
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
    final file =
        await rootBundle.loadString("assets/state-emergency-lines.json");

    final List states = jsonDecode(file);
    statesList = states;
    isLoading = false;
    setState(() {});
  }

  _submitSos() async {
    try {
      if (selectedState != null) {
        setState(() => isLoading = true);

        final location = new Location();
        final currentLocation = await location.getLocation();
        final currentLocationName = await ApiClient().getAddressFromCoordinates(
          currentLocation.latitude!,
          currentLocation.longitude!,
        );
        final message =
            "SOS from SmartRR App!\nI need help!\nLocation: ${currentLocationName}";
        final emergencyLines = selectedState!["emergency_lines"] as List;

        final String phoneNumber =
            emergencyLines.first.replaceFirst(r'0', '234');

        await ApiClient().sendSMS(
          phoneNumber: phoneNumber,
          message: message,
        );

        showToast(msg: "SOS Successful", type: "success");
      }
    } catch (e) {
      showToast(msg: e.toString(), type: "error");
    } finally {
      setState(() => isLoading = false);
      Navigator.pop(context);
    }
  }

  @override
  void initState() {
    _getStates();
    super.initState();
  }
}
