import 'package:flutter/material.dart';
import 'package:smartrr/generated/l10n.dart';
import 'package:smartrr/services/country_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartrr/services/database_service.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key key}) : super(key: key);

  @override
  State<SelectCountry> createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  String country;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).selectCountry)),
      body: StreamBuilder(
        builder: (context, snapshot) => snapshot.hasError
            ? Center(child: Text("Something went wrong"))
            : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                snapshot.hasData
                    ? Container(
                        constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height,
                            maxWidth: MediaQuery.of(context).size.width),
                        child: ListView.builder(
                            itemCount: snapshot.data.length,
                            itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    setState(() {
                                      country = snapshot.data[index].name;
                                    });
                                    _updateCountry(snapshot.data[index].name);
                                  },
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(snapshot.data[index].name),
                                  leading: Radio(
                                    value: snapshot.data[index].name,
                                    groupValue: country,
                                    onChanged: (val) {},
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
    final User _currentUser = FirebaseAuth.instance.currentUser;

    await DatabaseService(email: _currentUser.email).updateUser(
        {"country": country}).then((value) => Navigator.of(context).pop());
  }
}
