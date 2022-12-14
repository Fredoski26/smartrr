import 'package:flutter/material.dart';
import 'circular_progress.dart';

Future<bool> _willPopCallback() async {
  return false; // return true if the route to be popped
}

showLoading({required String message, required BuildContext context}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      title: Center(
        child: CircularProgress(),
      ),
      content: WillPopScope(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(message),
          ],
        ),
        onWillPop: _willPopCallback,
      ),
    ),
  );
}
