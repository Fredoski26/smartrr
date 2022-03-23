import 'package:smartrr/models/country.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

abstract class CountryService {
  static Future<List<Country>> getCountries() async {
    final response = await http
        .get(Uri.parse("https://countriesnow.space/api/v0.1/countries"));

    final body = json.decode(response.body);
    final List data = body["data"];

    return data
        .map((country) =>
            Country(name: country["country"], code: country["iso3"]))
        .toList();
  }

  static Future<List> getStates(String country) async {
    if (country == "Nigeria") {
      final response = await http
          .get(Uri.parse("http://locationsng-api.herokuapp.com/api/v1/states"));

      final body = json.decode(response.body);

      return body;
    } else {
      final response = await http.get(
        Uri.parse(
            "https://countriesnow.space/api/v0.1/countries/states/q?country=$country"),
      );

      final body = json.decode(response.body);

      return body["data"]["states"];
    }
  }

  static Future<List> getCities(String country, String state) async {
    if (country == "Nigeria") {
      final response = await http.get(Uri.parse(
          "http://locationsng-api.herokuapp.com/api/v1/states/$state/lgas"));

      final body = json.decode(response.body);

      return body;
    } else {
      final response = await http.get(
        Uri.parse(
            "https://countriesnow.space/api/v0.1/countries/state/cities/q?country=$country&state=$state"),
      );

      final body = json.decode(response.body);

      return body["data"];
    }
  }
}
