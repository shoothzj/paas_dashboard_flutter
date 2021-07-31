import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';

class SettingsViewModel extends ChangeNotifier {
  String language = "zh";

  SettingsViewModel() {
    if (!kIsWeb) {
      this.language = Platform.localeName.split("_")[0];
    }
  }

  void setLan(String lan) {
    this.language = lan;
    switch (lan) {
      case "zh":
        S.load(Locale('zh', 'CN'));
        break;
      case "en":
        S.load(Locale('en', 'US'));
        break;
    }
    notifyListeners();
  }
}
