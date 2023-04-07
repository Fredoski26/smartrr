import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:smartrr/env/env.dart';

class ApiClient {
  Future<String> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    final response = await http.post(
        Uri.parse(
            'https://maps.googleapis.com/maps/api/geocode/json?latlng=$latitude,$longitude&key=${Env.googleMapsApiKey}'),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/x-www-form-urlencoded"
        });
    var jsonResponse = json.decode(response.body);
    // var newList = jsonResponse['response'];
    // print('Address from coordinates: $jsonResponse');

    return jsonResponse['results'][0]['formatted_address'];
  }

  Future<dynamic> sendSMS({
    required dynamic phoneNumber,
    required String message,
  }) async {
    print(Env.africastalkingApiBaseUrl);
    var response =
        await http.post(Uri.parse(Env.africastalkingApiBaseUrl), headers: {
      "Accept": "application/json",
      "Content-Type": "application/x-www-form-urlencoded",
      "apiKey": Env.africastalkingApiKey,
    }, body: {
      "username": Env.africastalkingUsername,
      "message": message,
      "from": Env.africastalkingUsername,
      "to": (phoneNumber is List) ? phoneNumber : [phoneNumber],
    });

    print(response);

    var jsonResponse = jsonDecode(response.body);
    return jsonResponse;
  }
}
