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
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:sprintf/sprintf.dart';

class MysqlTableColumnViewModel extends BaseLoadListPageViewModel<Object> {
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

  MysqlTableColumnViewModel(this.mysqlInstancePo, this.dbname, this.tableName);

  List<String> getColumns() {
    return columns == null ? [''] : columns!;
  }

  Future<void> fetchData() async {
    try {
      MysqlSqlResult result = await MysqlDatabaseApi.getSqlData(
          sprintf(MysqlDatabaseApi.TABLE_COLUMN, [tableName, dbname]), mysqlInstancePo, MysqlDatabaseApi.SCHEMA_DB);
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
    List<Object> v = obj;
    return DataRow(cells: v.map((e) => DataCell(SelectableText(e.toString()))).toList());
  }

  MysqlTableColumnViewModel deepCopy() {
    return MysqlTableColumnViewModel(mysqlInstancePo.deepCopy(), dbname, tableName);
  }
}
