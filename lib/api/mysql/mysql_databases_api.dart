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

import 'package:mysql1/mysql1.dart';
import 'package:paas_dashboard_flutter/module/mysql/mysql_database.dart';
import 'package:paas_dashboard_flutter/module/mysql/mysql_sql_result.dart';
import 'package:paas_dashboard_flutter/module/mysql/mysql_table.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/ui/component/dynamic_filter_table.dart';
import 'package:sprintf/sprintf.dart';

class MysqlDatabaseApi {
  static const String SELECT_ALL = "select * from %s %s limit 100";
  static const String SCHEMA_DB = "information_schema";

  static const String TABLE_COLUMN =
      "select COLUMN_NAME, COLUMN_DEFAULT, IS_NULLABLE, DATA_TYPE,COLUMN_TYPE  from `COLUMNS` where TABLE_NAME = '%s' and TABLE_SCHEMA = '%s'";

  static const String TABLE_INDEX =
      "select INDEX_NAME, COLUMN_NAME, SEQ_IN_INDEX, INDEX_TYPE from STATISTICS where TABLE_NAME = '%s' and TABLE_SCHEMA = '%s'";

  static Future<List<DatabaseResp>> getDatabaseList(String host, int port, String username, String password) async {
    final setting = new ConnectionSettings(host: host, port: port, user: username, password: password);
    final MySqlConnection conn = await MySqlConnection.connect(setting);
    var queryResult = await conn.query('show databases');
    List<DatabaseResp> result = [];
    for (var row in queryResult) {
      result.add(new DatabaseResp(row[0]));
    }
    await conn.close();
    return result;
  }

  static Future<List<TableResp>> getTableList(
      String host, int port, String username, String password, String db) async {
    final setting = new ConnectionSettings(host: host, port: port, user: username, password: password, db: db);
    final MySqlConnection conn = await MySqlConnection.connect(setting);
    var queryResult = await conn.query('show tables');
    List<TableResp> result = [];
    for (var row in queryResult) {
      result.add(new TableResp(row[0]));
    }
    await conn.close();
    return result;
  }

  static Future<MysqlSqlResult> getData(
      MysqlInstancePo mysqlConn, String dbname, String tableName, String where) async {
    MysqlSqlResult result = MysqlSqlResult.create();
    try {
      final setting = new ConnectionSettings(
          host: mysqlConn.host,
          port: mysqlConn.port,
          user: mysqlConn.username,
          password: mysqlConn.password,
          db: dbname);
      final MySqlConnection conn = await MySqlConnection.connect(setting);
      var queryResult = await conn.query(sprintf(SELECT_ALL, [tableName, where]));
      List<List<Object?>> data = [];
      for (var row in queryResult) {
        if (row.values != null) {
          data.add(row.values!);
        }
      }
      result.setFieldName = queryResult.fields.map((e) => e.name!.isNotEmpty ? e.name.toString() : "").toList();
      result.setData = data;
      await conn.close();
    } catch (e) {
      throw Exception('Exception: ${e.toString()}');
    }
    return result;
  }

  static Future<MysqlSqlResult> getSqlData(String sql, MysqlInstancePo mysqlConn, String dbname) async {
    final setting = new ConnectionSettings(
        host: mysqlConn.host, port: mysqlConn.port, user: mysqlConn.username, password: mysqlConn.password, db: dbname);
    MysqlSqlResult result = MysqlSqlResult.create();
    final MySqlConnection conn = await MySqlConnection.connect(setting);
    var queryResult = await conn.query(sql);
    if (queryResult.isNotEmpty) {
      List<List<Object>> data = [];
      for (var row in queryResult) {
        if (row.values != null) {
          data.add(row.values!.map((e) => e == null ? "" : e).toList());
        }
      }
      result.setFieldName = queryResult.fields.map((e) => e.name!.isNotEmpty ? e.name.toString() : "").toList();
      result.setData = data;
    }
    await conn.close();
    return result;
  }

  static Future<List<String>> getUsers(String host, int port, String username, String password) async {
    final setting = new ConnectionSettings(host: host, port: port, user: username, password: password, db: "mysql");
    final MySqlConnection conn = await MySqlConnection.connect(setting);
    var queryResult = await conn.query("select User from user");
    List<String> result = [];
    for (var row in queryResult) {
      result.add(row[0]);
    }
    await conn.close();
    return result;
  }

  static String getWhere(List<DropDownButtonData>? filters) {
    String where = "";
    if (filters == null || filters.isEmpty) {
      return where;
    }
    where += "where ";
    for (int i = 0; i < filters.length; i++) {
      String column = filters[i].column;
      String op = getWhereOP(filters[i].op);
      where = where + column + sprintf(op, [getOPValue(filters[i].value!, filters[i].type, filters[i].op)]);
      if (i != filters.length - 1) {
        where += filters[i].join ? " and " : " or ";
      }
    }
    return where;
  }

  static String getOPValue(String value, TYPE type, OP op) {
    if (OP.BEGIN == op || OP.END == op || OP.CONTAIN == op || OP.EXCLUDE == op || OP.INCLUDE == op) {
      return value;
    } else if (OP.NULL == op || OP.NOT_NULL == op) {
      return "";
    } else {
      return type == TYPE.TEXT ? sprintf("'%s'", [value]) : value;
    }
  }

  static String getWhereOP(OP op) {
    switch (op) {
      case OP.EQ:
        return " = %s ";
      case OP.NOT_EQ:
        return " != %s ";
      case OP.LT:
        return " < %s ";
      case OP.GT:
        return " > %s ";
      case OP.LT_EQ:
        return " <= %s ";
      case OP.GT_EQ:
        return " >= %s ";
      case OP.NULL:
        return " is null ";
      case OP.NOT_NULL:
        return " is not null ";
      case OP.INCLUDE:
        return " in (%s) ";
      case OP.EXCLUDE:
        return " not in (%s) ";
      case OP.BEGIN:
        return " like '%s%%' ";
      case OP.END:
        return " like '%%%s' ";
      case OP.CONTAIN:
        return " like '%%%s%%' ";
    }
  }
}
