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

  Future<List<String>> getStates(String country) async {
    final response = await http.post(
        Uri.parse("https://countriesnow.space/api/v0.1/countries/cities"),
        body: {"country": country});

    final body = json.decode(response.body);

    return body["data"];
  }
}
