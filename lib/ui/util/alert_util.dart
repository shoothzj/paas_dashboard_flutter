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

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';

class AlertUtil {
  static void exceptionDialog(Exception exception, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertUtil.create(exception, context);
        });
  }

  static void createDialog(String msg, BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertUtil.create(msg, context);
        });
  }

  static AlertDialog create(Object? error, BuildContext context) {
    return AlertDialog(
      title: Text(
        error.runtimeType == Exception ? S.of(context).anErrorOccurred : S.of(context).hint,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.redAccent,
        ),
      ),
      content: SelectableText(
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
