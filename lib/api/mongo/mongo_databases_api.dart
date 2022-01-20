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

import 'package:mongo_dart/mongo_dart.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_database.dart';

class MongoDatabaseApi {
  static Future<List<DatabaseResp>> getDatabaseList(String addr, String username, String password) async {
    var db = await Db.create(addr);
    await db.open();
    var databases = await db.listDatabases();
    return databases.map((name) => new DatabaseResp(name)).toList();
  }
}
