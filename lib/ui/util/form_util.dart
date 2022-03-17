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

import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/module/util/csv_utils.dart';

class FormFieldDef {
  String fieldName;

  FormFieldDef(this.fieldName);
}

class FormUtil {
  static const String CANCEL = 'cancel';
  static const String CREATE = 'create';

  static Map<String, Map<String, String>> lastMap = new HashMap();

  static ButtonStyleButton createButton5(String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context,
      Function(String, String, String, String, String) callback) {
    if (formFieldDefList.length != 5) {
      throw AssertionError('args not match');
    }
    return createButton(
        resourceName, formFieldDefList, context, (list) => callback(list[0], list[1], list[2], list[3], list[4]));
  }

  static ButtonStyleButton createButton4(String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context,
      Function(String, String, String, String) callback) {
    if (formFieldDefList.length != 4) {
      throw AssertionError('args not match');
    }
    return createButton(
        resourceName, formFieldDefList, context, (list) => callback(list[0], list[1], list[2], list[3]));
  }

  static ButtonStyleButton createButton3(String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context,
      Function(String, String, String) callback) {
    if (formFieldDefList.length != 3) {
      throw AssertionError('args not match');
    }
    return createButton(resourceName, formFieldDefList, context, (list) => callback(list[0], list[1], list[2]));
  }

  static ButtonStyleButton createButton2(String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context,
      Function(String, String) callback) {
    if (formFieldDefList.length != 2) {
      throw AssertionError('args not match');
    }
    return createButton(resourceName, formFieldDefList, context, (list) => callback(list[0], list[1]));
  }

  static ButtonStyleButton createButton1(
      String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context, Function(String) callback) {
    if (formFieldDefList.length != 1) {
      throw AssertionError('args not match');
    }
    return createButton(resourceName, formFieldDefList, context, (list) => callback(list[0]));
  }

  static ButtonStyleButton createButton(
      String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context, Function(List<String>) callback) {
    lastMap.putIfAbsent(
        resourceName,
        () => HashMap.fromIterables(
            formFieldDefList.map((e) => e.fieldName).toList(), Iterable.generate(formFieldDefList.length, (i) => "")));
    return TextButton(
        onPressed: () {
          var editControllerList =
              formFieldDefList.map((e) => TextEditingController(text: lastMap[resourceName]![e.fieldName])).toList();
          List<TextFormField> formFieldsList = List.generate(
              formFieldDefList.length,
              (index) => TextFormField(
                    decoration: InputDecoration(labelText: formFieldDefList[index].fieldName),
                    controller: editControllerList[index],
                  ));
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(resourceName + ' Form'),
                  content: Form(
                      child: Column(
                    children: formFieldsList,
                  )),
                  actions: [
                    ElevatedButton(
                      child: Text(CREATE),
                      onPressed: () {
                        var list = editControllerList.map((e) => e.value.text).toList();
                        callback(list);
                        lastMap[resourceName] = HashMap.fromIterables(formFieldDefList.map((e) => e.fieldName).toList(),
                            editControllerList.map((e) => e.value.text));
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text(CANCEL),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Text('Create ' + resourceName));
  }

  static ButtonStyleButton createButton2NoText(String resourceName, List<FormFieldDef> formFieldDefList,
      BuildContext context, Function(String, String) callback) {
    if (formFieldDefList.length != 2) {
      throw AssertionError('args not match');
    }
    return createButtonNoText(resourceName, formFieldDefList, context, (list) => callback(list[0], list[1]));
  }

  static ButtonStyleButton createButtonNoText(
      String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context, Function(List<String>) callback) {
    lastMap.putIfAbsent(
        resourceName,
        () => HashMap.fromIterables(
            formFieldDefList.map((e) => e.fieldName).toList(), Iterable.generate(formFieldDefList.length, (i) => "")));
    return TextButton(
        onPressed: () {
          var editControllerList =
              formFieldDefList.map((e) => TextEditingController(text: lastMap[resourceName]![e.fieldName])).toList();
          List<TextFormField> formFieldsList = List.generate(
              formFieldDefList.length,
              (index) => TextFormField(
                    decoration: InputDecoration(labelText: formFieldDefList[index].fieldName),
                    controller: editControllerList[index],
                  ));
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(resourceName),
                  content: Form(
                      child: Column(
                    children: formFieldsList,
                  )),
                  actions: [
                    ElevatedButton(
                      child: Text(CREATE),
                      onPressed: () {
                        var list = editControllerList.map((e) => e.value.text).toList();
                        callback(list);
                        lastMap[resourceName] = HashMap.fromIterables(formFieldDefList.map((e) => e.fieldName).toList(),
                            editControllerList.map((e) => e.value.text));
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text(CANCEL),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Text(resourceName));
  }

  static ButtonStyleButton updateButton3(String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context,
      Function(String, String, String) callback) {
    if (formFieldDefList.length != 3) {
      throw AssertionError('args not match');
    }
    return updateButton(resourceName, formFieldDefList, context, (list) => callback(list[0], list[1], list[2]));
  }

  static ButtonStyleButton updateButton2(String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context,
      Function(String, String) callback) {
    if (formFieldDefList.length != 2) {
      throw AssertionError('args not match');
    }
    return updateButton(resourceName, formFieldDefList, context, (list) => callback(list[0], list[1]));
  }

  static ButtonStyleButton updateButton1(
      String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context, Function(String) callback) {
    if (formFieldDefList.length != 1) {
      throw AssertionError('args not match');
    }
    return updateButton(resourceName, formFieldDefList, context, (list) => callback(list[0]));
  }

  static ButtonStyleButton updateButton(
      String resourceName, List<FormFieldDef> formFieldDefList, BuildContext context, Function(List<String>) callback) {
    lastMap.putIfAbsent(
        resourceName,
        () => HashMap.fromIterables(
            formFieldDefList.map((e) => e.fieldName).toList(), Iterable.generate(formFieldDefList.length, (i) => "")));
    return TextButton(
        onPressed: () {
          var editControllerList =
              formFieldDefList.map((e) => TextEditingController(text: lastMap[resourceName]![e.fieldName])).toList();
          List<TextFormField> formFieldsList = List.generate(
              formFieldDefList.length,
              (index) => TextFormField(
                    decoration: InputDecoration(labelText: formFieldDefList[index].fieldName),
                    controller: editControllerList[index],
                  ));
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text(resourceName + ' Form'),
                  content: Form(
                      child: Column(
                    children: formFieldsList,
                  )),
                  actions: [
                    ElevatedButton(
                      child: Text(CREATE),
                      onPressed: () {
                        var list = editControllerList.map((e) => e.value.text).toList();
                        callback(list);
                        lastMap[resourceName] = HashMap.fromIterables(formFieldDefList.map((e) => e.fieldName).toList(),
                            editControllerList.map((e) => e.value.text));
                        Navigator.of(context).pop();
                      },
                    ),
                    ElevatedButton(
                      child: Text(CANCEL),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              });
        },
        child: Text('Update ' + resourceName));
  }

  static ButtonStyleButton createExportButton(List<String> header, List<List<dynamic>> data, BuildContext context) {
    return TextButton(
        onPressed: () async {
          String error = "";
          bool rs = false;
          try {
            rs = await CsvUtils.export(header, data);
          } on Exception catch (e) {
            error = e.toString();
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                  title: Text(
                    rs ? S.of(context).success : S.of(context).failure + error,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    new TextButton(
                      child: new Text(S.of(context).confirm),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
            },
          );
        },
        child: Text(S.of(context).export));
  }

  static ButtonStyleButton createImportButton(
      List<String> fieldSet, BuildContext context, Function(List<dynamic>) callback) {
    return TextButton(
        onPressed: () async {
          String error = "";
          List<List>? rs;
          try {
            rs = await CsvUtils.import();
            // csv header index, which means csv header can change location
            Map<String, int> indexMap = new HashMap();
            int index = 0;
            // get title and validate
            rs[0].forEach((element) {
              if (!fieldSet.contains(element)) {
                throw Exception('import file wrong,invalid column field $element');
              }
              indexMap[element] = index++;
            });
            // remove header
            rs.removeAt(0);
            rs.forEach((dataElement) {
              var dataList = <dynamic>[];
              fieldSet.forEach((fieldName) {
                dataList.add(dataElement[indexMap[fieldName]!]);
              });
              callback(dataList);
            });
          } on Exception catch (e) {
            error = e.toString();
          }
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return new AlertDialog(
                  title: Text(
                    error == "" ? S.of(context).success : S.of(context).failure + error,
                    textAlign: TextAlign.center,
                  ),
                  actions: [
                    new TextButton(
                      child: new Text(S.of(context).confirm),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ]);
            },
          );
        },
        child: Text(S.of(context).import));
  }
}
