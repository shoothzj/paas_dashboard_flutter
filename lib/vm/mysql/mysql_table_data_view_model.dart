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
import 'package:paas_dashboard_flutter/api/mysql/mysql_databases_api.dart';
import 'package:paas_dashboard_flutter/module/mysql/mysql_sql_result.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/ui/component/dynamic_filter_table.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';

class MysqlTableDataViewModel extends BaseLoadListPageViewModel<List> implements FilterCallBack {
  MysqlInstancePo mysqlInstancePo;

  String dbname;

  String tableName;

  List<String>? columns;

  String get instanceName {
    return mysqlInstancePo.name;
  }

  String getDbname() {
    return dbname;
  }

  String getTableName() {
    return tableName;
  }

  List<List> getData() {
    return displayList;
  }

  MysqlTableDataViewModel(this.mysqlInstancePo, this.dbname, this.tableName);

  List<String> getColumns() {
    return columns == null ? [''] : columns!;
  }

  Future<void> fetchData(List<DropDownButtonData>? filters) async {
    try {
      String where = MysqlDatabaseApi.getWhere(filters);

      MysqlSqlResult result = await MysqlDatabaseApi.getData(mysqlInstancePo, dbname, tableName, where);
      columns = result.getFieldName;
      fullList = result.getData;
      displayList = fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      opException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> fetchSqlData(String sql) async {
    if (sql.isEmpty) {
      fullList = [];
      displayList = fullList;
      loadSuccess();
      notifyListeners();
      return;
    }
    try {
      MysqlSqlResult result = await MysqlDatabaseApi.getSqlData(sql, mysqlInstancePo, dbname);
      columns = result.getFieldName;
      fullList = result.getData;
      displayList = fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  DataRow getConvert(dynamic obj) {
    List<dynamic> v = obj;
    return DataRow(
        cells: v
            .map((e) => DataCell(e == null
                ? const SelectableText("(N/A)", style: TextStyle(color: Colors.grey))
                : SelectableText(e.toString())))
            .toList());
  }

  MysqlTableDataViewModel deepCopy() {
    return MysqlTableDataViewModel(mysqlInstancePo.deepCopy(), dbname, tableName);
  }

  @override
  void execute(List<DropDownButtonData> rowData) {
    fetchData(rowData);
  }
}
