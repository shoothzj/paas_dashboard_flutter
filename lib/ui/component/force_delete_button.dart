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

class ForceDeleteButton extends StatefulWidget {
  final Function(bool) callback;

  ForceDeleteButton(this.callback);

  @override
  State<StatefulWidget> createState() {
    return new __ForceDeleteButtonState(callback);
  }
}

class __ForceDeleteButtonState extends State<ForceDeleteButton> {
  bool forceDelete = false;

  final Function(bool) callback;

  __ForceDeleteButtonState(this.callback);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return StatefulBuilder(builder: (context, setState) {
                  return AlertDialog(
                    title: Text(
                      S.of(context).confirmDeleteQuestion,
                      textAlign: TextAlign.center,
                    ),
                    content: Container(
                      width: 300,
                      height: 40,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        children: [
                          SizedBox(
                            width: 10,
                          ), //SizedBox
                          Text(S.of(context).forceDelete), //Text
                          SizedBox(width: 10),
                          Checkbox(
                            value: this.forceDelete,
                            onChanged: (value) {
                              setState(() {
                                if (value == null) {
                                  this.forceDelete = false;
                                } else {
                                  this.forceDelete = value;
                                }
                              });
                            },
                          )
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text(
                          S.of(context).cancel,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(
                          S.of(context).confirm,
                        ),
                        onPressed: () {
                          callback.call(forceDelete);
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
              });
        },
        icon: Icon(Icons.delete));
  }
}
