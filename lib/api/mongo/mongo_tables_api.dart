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

import 'package:mongo_dart/mongo_dart.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_sql_result.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_table.dart';

class MongoTablesApi {
  static Future<List<TableResp>> getTableList(
      String addr, String username, String password, String databaseName) async {
    var db = await Db.create(addr + "/" + databaseName);
    await db.open();
    var collectionNames = await db.getCollectionNames();
    db.close();
    return collectionNames.whereType<String>().map((name) {
      return new TableResp(name);
    }).toList();
  }

  static Future<MongoSqlResult> getTableData(
      String addr, String username, String password, String databaseName, String tableName) async {
    var db = await Db.create(addr + "/" + databaseName);
    await db.open();
    var collection = db.collection(tableName);
    SelectorBuilder builder = SelectorBuilder().limit(100);
    List<Map<String, dynamic>> data = await collection.find(builder).toList();
    db.close();
    MongoSqlResult result = MongoSqlResult.create();
    if (data.isEmpty) {
      return result;
    }
    LinkedHashSet<String> fieldNames = new LinkedHashSet();
    List<List<Object?>> sqldata = [];
    data.forEach((element) {
      fieldNames.addAll(element.keys);
    });
    data.forEach((element) {
      List<Object?> temp = [];
      fieldNames.forEach((fieldName) {
        temp.add(element[fieldName]);
      });
      sqldata.add(temp);
    });
    result.fieldName = fieldNames;
    result.data = sqldata;
    return result;
  }
}
