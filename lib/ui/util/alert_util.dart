import 'package:flutter/material.dart';

class AlertUtil {
  static void exceptionDialog(Exception exception, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertUtil.create(exception, context);
        });
  }

  static AlertDialog create(Object? error, BuildContext context) {
    return AlertDialog(
      title: Text(
        'An Error Occured!',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.redAccent,
        ),
      ),
      content: Text(
        "$error",
        style: TextStyle(
          color: Colors.blueAccent,
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'Go Back',
            style: TextStyle(
              color: Colors.redAccent,
            ),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        )
      ],
    );
  }
}
