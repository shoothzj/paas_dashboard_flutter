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

import 'package:paas_dashboard_flutter/api/redis/redis_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/redis_instance_po.dart';
import 'package:paas_dashboard_flutter/ui/redis/widget/redis_instance_dart.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class RedisInstanceViewModel extends BaseLoadViewModel {
  final RedisInstancePo redisInstancePo;

  RedisInstanceViewModel(this.redisInstancePo);

  dynamic result = "";

  RedisInstanceViewModel deepCopy() {
    return new RedisInstanceViewModel(redisInstancePo.deepCopy());
  }

  int get id {
    return this.redisInstancePo.id;
  }

  String get name {
    return this.redisInstancePo.name;
  }

  String get ip {
    return this.redisInstancePo.ip;
  }

  String get password {
    return this.redisInstancePo.password;
  }

  int get port {
    return this.redisInstancePo.port;
  }

  String get executeResult {
    return this.result.toString();
  }

  Future<void> execute(OP op, List<String> value) async {
    dynamic reply;
    try {
      switch (op) {
        case OP.KEYS:
          reply = await RedisApi.keys(ip, port, password, value[0]);
          break;
        case OP.GET:
          reply = await RedisApi.get(ip, port, password, value[0]);
          break;
        case OP.SET:
          reply = await RedisApi.set(ip, port, password, value[0], value[1]);
          break;
        case OP.DELETE:
          reply = await RedisApi.delete(ip, port, password, value[0]);
          break;
        case OP.HSET:
          reply = await RedisApi.hSet(ip, port, password, value[0], value[1], value[2]);
          break;
        case OP.HGET:
          reply = await RedisApi.hGet(ip, port, password, value[0], value[1]);
          break;
        case OP.HGETALL:
          reply = await RedisApi.hGetAll(ip, port, password, value[0]);
          break;
        case OP.HDEL:
          reply = await RedisApi.hDel(ip, port, password, value[0], value[1]);
          break;
      }
      result = reply;
      loading = true;
    } on Exception catch (e) {
      loading = false;
      opException = e;
    }
    notifyListeners();
  }
}
