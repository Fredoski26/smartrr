import 'package:flutter/material.dart';
import 'package:smartrr/generated/l10n.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _language = S.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(_language.aboutSmartRR)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/logo.png"),
                ),
              ],
            ),
            Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 33.0, horizontal: 36.0),
              child: Text(
                _language.aboutSmartrrData,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
