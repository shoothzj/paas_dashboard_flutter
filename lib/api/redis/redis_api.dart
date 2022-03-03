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
  static Future<dynamic> set(String host, int port, String password, String key, String value) async {
    final command = await getCommand(host, port, password);
    dynamic rs = await command
        .send_object(["SET", key, value]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    return rs;
  }

  static Future<dynamic> get(String host, int port, String password, String key) async {
    final command = await getCommand(host, port, password);
    dynamic rs =
        await command.send_object(["GET", key]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    await command.get_connection().close();
    return rs;
  }

  static Future<dynamic> delete(String host, int port, String password, String key) async {
    final command = await getCommand(host, port, password);
    dynamic rs =
        await command.send_object(["DEL", key]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    return rs;
  }

  static dynamic keys(String host, int port, String password, String patten) async {
    final command = await getCommand(host, port, password);
    dynamic rs = await command
        .send_object(["KEYS", patten]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    await command.get_connection().close();
    return rs;
  }

  static Future<dynamic> hGet(String host, int port, String password, String key, String field) async {
    final command = await getCommand(host, port, password);
    dynamic rs = await command
        .send_object(["HGET", key, field]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    return rs;
  }

  static Future<dynamic> hSet(
      String host, int port, String password, String key, String field, String fieldValue) async {
    final command = await getCommand(host, port, password);
    dynamic rs = await command.send_object(["HSET", key, field, fieldValue]).onError(
        (error, stackTrace) => throw Exception('redis error: $error'));
    return rs;
  }

  static Future<dynamic> hGetAll(String host, int port, String password, String key) async {
    final command = await getCommand(host, port, password);
    dynamic rs = await command
        .send_object(["HGETALL", key]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    return rs;
  }

  static Future<dynamic> hDel(String host, int port, String password, String key, String field) async {
    final command = await getCommand(host, port, password);
    dynamic rs = await command
        .send_object(["HDEL", key, field]).onError((error, stackTrace) => throw Exception('redis error: $error'));
    return rs;
  }

  static Future<Command> getCommand(String host, int port, String password) async {
    final command = await RedisConnection().connect(host, port);
    try {
      await command.send_object(["AUTH", password]);
    } catch (e) {
      throw Exception('Password Error Exception: ${e.toString()}');
    }
    return command;
  }
}
