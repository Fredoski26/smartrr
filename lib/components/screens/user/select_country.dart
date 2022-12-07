import 'package:flutter/material.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/models/country.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:smartrr/services/database_service.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({super.key, this.userCountry});

  final String? userCountry;

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  late String country;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    country = widget.userCountry!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).selectCountry),
        actions: [
          TextButton(
            onPressed: () => _updateCountry(country),
            child: _isLoading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    "Done",
                    style: TextStyle().copyWith(fontWeight: FontWeight.bold),
                  ),
          )
        ],
      ),
      body: StreamBuilder<List<Country>>(
        builder: (context, AsyncSnapshot<List<Country>> snapshot) =>
            snapshot.hasError
                ? Center(child: Text("Something went wrong"))
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    snapshot.hasData
                        ? Container(
                            constraints: BoxConstraints(
                                maxHeight: MediaQuery.of(context).size.height,
                                maxWidth: MediaQuery.of(context).size.width),
                            child: ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) => ListTile(
                                      onTap: () {
                                        setState(() {
                                          country = snapshot.data![index].name;
                                        });
                                      },
                                      contentPadding: EdgeInsets.zero,
                                      title: Text(snapshot.data![index].name),
                                      leading: Radio(
                                        value: snapshot.data![index].name,
                                        groupValue: country,
                                        onChanged: (String? val) {
                                          setState(() {
                                            country = val!;
                                          });
                                        },
                                      ),
                                    )),
                          )
                        : Center(child: CircularProgressIndicator())
                  ]),
        stream: CountryService.getCountries().asStream(),
      ),
    );
  }

  void _updateCountry(String country) async {
    setState(() {
      _isLoading = true;
    });
    await DatabaseService().updateUser({"country": country}).then(
        (value) => Navigator.of(context).pop());
  }
}
