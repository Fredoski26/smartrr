import 'package:flutter/material.dart';

Future showAction(
    {@required String actionText,
    @required String text,
    @required Function func,
    @required BuildContext context}) {
  Widget continueButton = FlatButton(
    onPressed: () => func(),
    child: Text(actionText, style: TextStyle(color: Colors.purple),),
  );
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => AlertDialog(
      elevation: 30,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      title: Text(
        text,
        style: TextStyle(
          fontSize: 16,
        ),
      ),
      actions: <Widget>[continueButton],
    ),
  );
}
