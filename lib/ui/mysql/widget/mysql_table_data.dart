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
import 'package:paas_dashboard_flutter/ui/component/dynamic_filter_table.dart';
import 'package:paas_dashboard_flutter/ui/mysql/widget/mysql_table_index.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_table_column_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_table_data_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_table_index_view_model.dart';
import 'package:provider/provider.dart';

import 'mysql_table_column.dart';

/// MySQL table data list windows
class MysqlTableDataWidget extends StatefulWidget {
  MysqlTableDataWidget();

  @override
  State<StatefulWidget> createState() {
    return new _MysqlTableDataState();
  }
}

class _MysqlTableDataState extends State<MysqlTableDataWidget> {
  DynamicFilterTable? filterTable;
  ColumnNotifier _notifier = new ColumnNotifier();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MysqlTableDataViewModel>(context, listen: false);
    vm.setDataConverter(vm.getConvert);
    vm.fetchData(null);
    filterTable = DynamicFilterTable(_notifier, vm);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MysqlTableDataViewModel>(context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    var dbsFuture = SingleChildScrollView(
      child: PaginatedDataTable(
        showCheckboxColumn: false,
        columns: vm
            .getColumns()
            .map((e) => DataColumn(
                    label: SelectableText(
                  e,
                  style: new TextStyle(color: Colors.red, fontSize: 20),
                )))
            .toList(),
        source: vm,
      ),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchData(null);
        },
        child: Text(S.of(context).refresh));
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
    MysqlTableColumnViewModel tableColumnVm =
        new MysqlTableColumnViewModel(vm.mysqlInstancePo, vm.dbname, vm.tableName);
    MysqlTableIndexViewModel indexColumnVm = new MysqlTableIndexViewModel(vm.mysqlInstancePo, vm.dbname, vm.tableName);
    _notifier.setColumns(vm.getColumns());
    var body = ListView(
      children: <Widget>[
        Container(
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: [
              new Row(children: [refreshButton, exportButton]),
              filterTable!
            ],
          ),
        ),
        dbsFuture
      ],
    );

    return DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mysql ${vm.instanceName} -> ${vm.getDbname()} DB -> ${vm.getTableName()} table'),
            bottom: TabBar(
              tabs: [
                Tab(text: S.of(context).data),
                Tab(text: S.of(context).tableColumn),
                Tab(text: S.of(context).tableIndex),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              body,
              ChangeNotifierProvider(
                create: (context) => tableColumnVm.deepCopy(),
                child: MysqlTableColumnWidget(),
              ).build(context),
              ChangeNotifierProvider(
                create: (context) => indexColumnVm.deepCopy(),
                child: MysqlTableIndexWidget(),
              ).build(context)
            ],
          ),
        ));
  }
}
