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

    List<Country> countries = data
        .map((country) =>
            Country(name: country["country"], code: country["iso3"]))
        .toList();

    // sort A-Z
    countries.sort((a, b) => a.name.compareTo(b.name));

    return countries;
  }

  static Future<List> getStates(String country) async {
    if (country == "Nigeria") {
      final jsonFile =
          await rootBundle.loadString("assets/nigeria-state-and-lgas.json");
      final List decodedFile = jsonDecode(jsonFile);

      List states = decodedFile
          .map((state) => {"id": state["alias"], "name": state["state"]})
          .toList();

      // sort A-Z
      states.sort((a, b) => a.toString().compareTo(b.toString()));

      return states;
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

      // sort A-Z
      lgas.sort();

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
