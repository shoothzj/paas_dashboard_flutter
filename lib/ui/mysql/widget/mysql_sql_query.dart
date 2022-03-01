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
import 'package:paas_dashboard_flutter/module/util/csv_utils.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_sql_query_view_model.dart';
import 'package:provider/provider.dart';

class MysqlSqlQueryWidget extends StatefulWidget {
  MysqlSqlQueryWidget();

  @override
  State<StatefulWidget> createState() {
    return new _MysqlSqlQueryWidgetState();
  }
}

class _MysqlSqlQueryWidgetState extends State<MysqlSqlQueryWidget> {
  TextEditingController textFieldController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MysqlSqlQueryViewModel>(context);

    var dataView = SingleChildScrollView(
      child: PaginatedDataTable(
        showCheckboxColumn: false,
        columns: vm.getColumns().map((e) => DataColumn(label: SelectableText(e))).toList(),
        source: vm,
      ),
    );

    var textField = TextField(
      controller: textFieldController,
      keyboardType: TextInputType.multiline,
      maxLines: 10,
      decoration: InputDecoration(
          hintText: S.of(context).sqlQueryMessage,
          border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(30)))),
    );

    var executeButton = TextButton(
        onPressed: () {
          TextSelection selection = textFieldController.selection;
          if (selection.start == selection.end) {
            vm.fetchSqlData(textFieldController.text.trim());
          } else {
            String selectedSql = textFieldController.text.substring(selection.start, selection.end);
            vm.fetchSqlData(selectedSql.trim());
          }
        },
        child: Text(S.of(context).execute));

    var exportButton = TextButton(
        onPressed: () async {
          String error = "";
          bool rs = false;
          try {
            rs = await CsvUtils.export(vm.getColumns(), vm.getData());
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

    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [executeButton, exportButton],
          ),
        ),
        Container(
          child: textField,
        ),
        Container(child: dataView),
      ],
    );

    return body;
  }
}
