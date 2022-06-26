import 'package:flutter/material.dart';

Future askAction(
    {@required String actionText,
    @required String cancelText,
    @required String text,
    @required BuildContext context,
    @required Function func,
    @required Function cancelFunc}) {
  Widget continueButton = TextButton(
    onPressed: () => func(),
    child: Text(actionText),
  );
  Widget cancelButton = TextButton(
    onPressed: () => cancelFunc(),
    child: Text(cancelText),
  );
  return showDialog(
    context: context,
    builder: (BuildContext context) => AlertDialog(
      elevation: 30,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(
        text,
        style: TextStyle(fontSize: 16),
      ),
      actions: <Widget>[cancelButton, continueButton],
    ),
  );
}
