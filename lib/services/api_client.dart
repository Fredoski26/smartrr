import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  Future<String> getAddressFromCoordinates(
      double latitude, double longitude, String apiKey) async {
    print("Got into getPosts");
    final response = await http.post(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=$apiKey'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        });
    debugPrint("GETTING THE LOC FROM LAT LONG " + response.body);
    var jsonResponse = json.decode(response.body);
    // var newList = jsonResponse['response'];
    // print('Address from coordinates: $jsonResponse');

    return jsonResponse['results'][0]['formatted_address'];
  }

  Future<dynamic> sendSMS({String phoneNumber, String message}) async {
    print("Got into getPosts");
//    ac89f1f3
//    EWXULOE0HO87RjBn
    var response = await http.post(
        Uri.parse(
            'https://rest.nexmo.com/sms/json?api_key=d11a9692&api_secret=HTouvYw3rHSOcV0C&to=$phoneNumber&from=+12023866052&text=$message'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        });
    var jsonResponse = json.decode(response.body);
    debugPrint("MSG RESPONSE: ${response.body}");
    return jsonResponse;
  }
}
