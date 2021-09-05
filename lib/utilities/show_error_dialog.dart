import 'package:flutter/material.dart';

class ShowErrorDialog {
  static void showAlertDialog(
      {@required String errorMessage, @required BuildContext context}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
