import 'package:flutter/services.dart';
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
      final jsonFile =
          await rootBundle.loadString("assets/nigeria-state-and-lgas.json");
      final List states = jsonDecode(jsonFile);

      return states
          .map((state) => {"id": state["alias"], "name": state["state"]})
          .toList();
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
      final jsonFile =
          await rootBundle.loadString("assets/nigeria-state-and-lgas.json");
      final List states = jsonDecode(jsonFile);

      List lgas = [];
      states.forEach((ng_state) {
        if (ng_state["state"] == state) {
          lgas = ng_state["lgas"];
        } else if (state == "Abuja" &&
            ng_state["state"] == "Federal Capital Territory") {
          lgas = ng_state["lgas"];
        }
      });

      return lgas;
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
