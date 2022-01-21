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

import 'package:redis/redis.dart';

class RedisApi {
  static Future<void> set(String host, int port, String username, String password, String key, String value) async {
    final conn = RedisConnection();
    Command connect = await conn.connect(host, port);
    await connect.send_object(["SET", key, value]);
  }

  static Future<String> get(String host, int port, String username, String password, String key) async {
    final conn = RedisConnection();
    Command connect = await conn.connect(host, port);
    return await connect.send_object(["GET", key]);
  }
}
