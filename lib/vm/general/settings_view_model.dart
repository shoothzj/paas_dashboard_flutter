import 'package:flutter/material.dart';

class SettingsViewModel extends ChangeNotifier {
  String language = 'en';

  void setLan(String lan) {
    this.language = lan;
    notifyListeners();
  }
}
