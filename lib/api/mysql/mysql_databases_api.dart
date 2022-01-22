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
import 'package:sprintf/sprintf.dart';

class MysqlDatabaseApi {
  static const String SELECT_ALL = "select * from %s limit 100";

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

  static Future<MysqlSqlResult> getData(MysqlInstancePo mysqlConn, String dbname, String? tableName) async {
    final setting = new ConnectionSettings(
        host: mysqlConn.host, port: mysqlConn.port, user: mysqlConn.username, password: mysqlConn.password, db: dbname);
    final MySqlConnection conn = await MySqlConnection.connect(setting);
    var queryResult = await conn.query(sprintf(SELECT_ALL, [tableName]));
    List<List<Object>> data = [];
    for (var row in queryResult) {
      if (row.values != null) {
        data.add(row.values!.map((e) => e == null ? "" : e).toList());
      }
    }
    MysqlSqlResult result = MysqlSqlResult.create();
    result.setFieldName = queryResult.fields.map((e) => e.name!.isNotEmpty ? e.name.toString() : "").toList();
    result.setData = data;
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
}
