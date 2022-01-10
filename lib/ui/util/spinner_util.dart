import 'package:flutter/material.dart';

class SpinnerUtil {
  static Widget create() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(height: 20),
          Text('This may take some time..')
        ],
      ),
    );
  }
}
