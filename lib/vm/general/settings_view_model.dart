//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

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
