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
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/mysql/widget/mysql_sql_query.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_sql_query_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_table_data_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_table_view_model.dart';
import 'package:provider/provider.dart';

/// mysql Database list windows
class MysqlTablesWidget extends StatefulWidget {
  MysqlTablesWidget();

  @override
  State<StatefulWidget> createState() {
    return new _MysqlTablesState();
  }
}

class _MysqlTablesState extends State<MysqlTablesWidget> {
  final searchTextController = TextEditingController();

  _MysqlTablesState();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MysqlTablesViewModel>(context, listen: false);
    searchTextController.addListener(() {
      vm.filter(searchTextController.text);
    });
    vm.fetchMysqlTables();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MysqlTablesViewModel>(context);

    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    var dbsFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [DataColumn(label: Text(S.of(context).tables))],
          rows: vm.displayList
              .map((data) => DataRow(
                      onSelectChanged: (bool? select) {
                        vm.tableName = data.tableName;
                        MysqlTableDataViewModel detailViewModel =
                            new MysqlTableDataViewModel(vm.mysqlInstancePo, vm.dbname, data.tableName);
                        Navigator.pushNamed(context, PageRouteConst.MysqlTable, arguments: detailViewModel.deepCopy());
                      },
                      cells: [
                        DataCell(
                          Text(data.tableName),
                        )
                      ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchMysqlTables();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton],
          ),
        ),
        SearchableTitle("table list", "search by table name", searchTextController),
        dbsFuture
      ],
    );
    MysqlSqlQueryViewModel sqlQueryVm = new MysqlSqlQueryViewModel(vm.mysqlInstancePo, vm.dbname);

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mysql ${vm.name} -> ${vm.getDbname()} DB'),
            bottom: TabBar(
              tabs: [
                Tab(text: S.of(context).tables),
                Tab(text: S.of(context).sqlQuery),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              body,
              ChangeNotifierProvider(
                create: (context) => sqlQueryVm.deepCopy(),
                child: MysqlSqlQueryWidget(),
              ).build(context)
            ],
          ),
        ));
  }
}
