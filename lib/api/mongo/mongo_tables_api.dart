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
import 'package:paas_dashboard_flutter/ui/component/dynamic_filter_table.dart';

class MongoTablesApi {
  static Future<List<TableResp>> getTableList(
      String addr, String username, String password, String databaseName) async {
    var db = await Db.create("$addr/$databaseName");
    await db.open();
    var collectionNames = await db.getCollectionNames();
    db.close();
    return collectionNames.whereType<String>().map((name) {
      return TableResp(name);
    }).toList();
  }

  static Future<MongoSqlResult> getTableData(String addr, String username, String password, String databaseName,
      String tableName, SelectorBuilder builder) async {
    try {
      var db = await Db.create("$addr/$databaseName");
      await db.open();
      var collection = db.collection(tableName);
      List<Map<String, dynamic>> data = await collection.find(builder).toList();
      db.close();
      MongoSqlResult result = MongoSqlResult.create();
      if (data.isEmpty) {
        return result;
      }
      LinkedHashSet<String> fieldNames = LinkedHashSet();
      List<List<Object?>> sqldata = [];
      for (var element in data) {
        fieldNames.addAll(element.keys);
      }
      for (var element in data) {
        List<Object?> temp = [];
        for (var fieldName in fieldNames) {
          temp.add(element[fieldName]);
        }
        sqldata.add(temp);
      }
      result.fieldName = fieldNames;
      result.data = sqldata;
      return result;
    } catch (e) {
      throw Exception('Exception: ${e.toString()}');
    }
  }

  static SelectorBuilder getSelectorBuilder(List<DropDownButtonData>? filters) {
    SelectorBuilder builder = SelectorBuilder();
    if (filters == null || filters.isEmpty) {
      return builder.limit(100);
    }
    builder = builderSelector(filters[0]);
    for (int i = 1; i < filters.length; i++) {
      DropDownButtonData data = filters[i];
      SelectorBuilder builderTemp = builderSelector(data);
      if (filters[i - 1].join) {
        builder.and(builderTemp);
      } else {
        builder.or(builderTemp);
      }
    }
    return builder;
  }

  static SelectorBuilder builderSelector(DropDownButtonData data) {
    dynamic value = parseValue(data.value ?? "", data.type);
    String column = data.column;
    switch (data.op) {
      case OP.EQ:
        return where.eq(column, value);
      case OP.NOT_EQ:
        return where.ne(column, value);
      case OP.LT:
        return where.lt(column, value);
      case OP.GT:
        return where.gt(column, value);
      case OP.LT_EQ:
        return where.lte(column, value);
      case OP.GT_EQ:
        return where.gte(column, value);
      case OP.NULL:
        return where.notExists(column);
      case OP.NOT_NULL:
        return where.exists(column);
      case OP.INCLUDE:
        return where.oneFrom(
            column, data.value == null ? [] : data.value!.split(",").map((e) => parseValue(e, data.type)).toList());
      case OP.EXCLUDE:
        return where.nin(
            column, data.value == null ? [] : data.value!.split(",").map((e) => parseValue(e, data.type)).toList());
      case OP.BEGIN:
        return where.match(column, "^$value");
      case OP.END:
        return where.match(column, value + "\$");
      case OP.CONTAIN:
        return where.match(column, "${"^.*$value"}.*\$");
    }
  }

  static dynamic parseValue(String value, TYPE type) {
    switch (type) {
      case TYPE.OBJECT_ID:
        return ObjectId.parse(value);
      case TYPE.TEXT:
        return value;
      case TYPE.NUMBER:
        return value.contains(".") ? double.parse(value) : int.parse(value);
    }
  }
}
