import 'dart:convert';
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
    Map<String, dynamic> data = {
      "sms": message,
      "from": Env.termiiSenderId,
      "to": phoneNumber,
      "type": "plain",
      "channel": "generic",
      "api_key": Env.termiiApiKey,
    };

    var response = await http.post(
      Uri.parse(Env.termiiApiBaseUrl),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) return true;
    throw "Something went wrong";
  }
}
