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

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_db.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_memory.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/code_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/redis_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/sql_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/zk_instance_po.dart';

class Persistent {
  static PersistentApi? api;

  static Future<PersistentApi> getApi() async {
    if (api == null) {
      if (!kIsWeb) {
        api = await PersistentDb.getInstance();
      } else {
        api = new PersistentMemory();
      }
    }
    return api!;
  }

  static Future<void> savePulsar(String name, String host, int port, String functionHost, int functionPort) async {
    return (await getApi()).savePulsar(name, host, port, functionHost, functionPort);
  }

  static Future<void> deletePulsar(int id) async {
    return (await getApi()).deletePulsar(id);
  }

  static Future<List<PulsarInstancePo>> pulsarInstances() async {
    return (await getApi()).pulsarInstances();
  }

  static Future<PulsarInstancePo?> pulsarInstance(String name) async {
    return await ((await getApi()).pulsarInstance(name));
  }

  static Future<void> saveBookkeeper(String name, String host, int port) async {
    return (await getApi()).saveBookkeeper(name, host, port);
  }

  static Future<void> deleteBookkeeper(int id) async {
    return (await getApi()).deleteBookkeeper(id);
  }

  static Future<List<BkInstancePo>> bookkeeperInstances() async {
    return (await getApi()).bookkeeperInstances();
  }

  static Future<BkInstancePo?> bookkeeperInstance(String name) async {
    return await ((await getApi()).bookkeeperInstance(name));
  }

  static Future<void> saveZooKeeper(String name, String host, int port) async {
    return (await getApi()).saveZooKeeper(name, host, port);
  }

  static Future<void> deleteZooKeeper(int id) async {
    return (await getApi()).deleteZooKeeper(id);
  }

  static Future<List<ZkInstancePo>> zooKeeperInstances() async {
    return (await getApi()).zooKeeperInstances();
  }

  static Future<ZkInstancePo?> zooKeeperInstance(String name) async {
    return await ((await getApi()).zooKeeperInstance(name));
  }

  static Future<void> saveKubernetesSsh(String name, List<SshStep> sshSteps) async {
    return (await getApi()).saveKubernetesSsh(name, sshSteps);
  }

  static Future<void> deleteKubernetes(int id) async {
    return (await getApi()).deleteKubernetes(id);
  }

  static Future<List<K8sInstancePo>> kubernetesInstances() async {
    return (await getApi()).kubernetesInstances();
  }

  static Future<void> saveMongo(String name, String addr, String username, String password) async {
    return (await getApi()).saveMongo(name, addr, username, password);
  }

  static Future<void> deleteMongo(int id) async {
    return (await getApi()).deleteMongo(id);
  }

  static Future<List<MongoInstancePo>> mongoInstances() async {
    return (await getApi()).mongoInstances();
  }

  static Future<void> saveMysql(String name, String host, int port, String username, String password) async {
    return (await getApi()).saveMysql(name, host, port, username, password);
  }

  static Future<void> deleteMysql(int id) async {
    return (await getApi()).deleteMysql(id);
  }

  static Future<List<MysqlInstancePo>> mysqlInstances() async {
    return (await getApi()).mysqlInstances();
  }

  static Future<void> saveSql(String name, String sql) async {
    return (await getApi()).saveSql(name, sql);
  }

  static Future<void> deleteSql(int id) async {
    return (await getApi()).deleteSql(id);
  }

  static Future<List<SqlPo>> sqlList() async {
    return (await getApi()).sqlList();
  }

  static Future<void> saveCode(String name, String sql) async {
    return (await getApi()).saveCode(name, sql);
  }

  static Future<void> deleteCode(int id) async {
    return (await getApi()).deleteCode(id);
  }

  static Future<List<CodePo>> codeList() async {
    return (await getApi()).codeList();
  }

  static Future<void> saveRedis(String name, String addr, String username, String password) async {
    return (await getApi()).saveRedis(name, addr, username, password);
  }

  static Future<void> deleteRedis(int id) async {
    return (await getApi()).deleteRedis(id);
  }

  static Future<List<RedisInstancePo>> redisInstances() async {
    return (await getApi()).redisInstances();
  }

  static Future<RedisInstancePo?> redisInstance(String name) async {
    return await ((await getApi()).redisInstance(name));
  }

  static bool supportDb() {
    return !kIsWeb;
  }
}
