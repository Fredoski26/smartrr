import 'package:flutter/material.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("About SMartRR")),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 33.0, horizontal: 36.0),
              child: Text(
                "Smart Reporting and Referral (SMART RR) is a technology based mobile application that allows survivors, social workers and service providers to report and refer cases/incidents of GBV from their smart and basic phones. The tool was developed by Big Family 360 Foundation, a national non-governmental organisation in Nigeria.\n\nSmart RR application is a technology based mobile application which enables survivors, social workers and service providers to report and refer GBV incidents to relevant service providers and authorities, conducts service mapping, automatically updates referral directory, collects and analyses referral data. This idea was built on the existing referral mechanism of the GBV Sub Sector which is done manually.\n\nThe application was therefore designed to mitigate existing challenges such as under reporting and associated difficulties with accessing services. The pilot rollout and deployment of Smart RR in Borno, Adamawa and Yobe States is with the technical guidance of UNFPA and the GBV Sub Sector with funding support from the Nigeria Humanitarian Fund (NHF).\n\nIt is part of the GBV Sub Sector's commitment to the localisation agenda. A series of meetings and presentations with the GBV Coordination teams provided for clarifications on how Smart RR can complement existing GBV tools and processes. A test run has been conducted within a group of GBV specialists in Borno and Adamawa States under the guidance of the GBV Strategic Advisory Group to ensure the application does not compromise survivor centred approaches to GBV service provision.",
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
