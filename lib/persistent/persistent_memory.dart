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

import 'package:paas_dashboard_flutter/module/bk/const.dart';
import 'package:paas_dashboard_flutter/module/mongo/const.dart';
import 'package:paas_dashboard_flutter/module/mysql/const.dart';
import 'package:paas_dashboard_flutter/module/pulsar/const.dart';
import 'package:paas_dashboard_flutter/module/redis/const.dart';
import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/module/zk/const.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/code_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/redis_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/sql_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/zk_instance_po.dart';

class PersistentMemory implements PersistentApi {
  @override
  Future<void> savePulsar(String name, String host, int port, String functionHost, int functionPort, bool enableTls,
      bool functionEnableTls, String caFile, String clientCertFile, String clientKeyFile, String clientKeyPassword) {
    // TODO: implement savePulsar
    throw UnimplementedError();
  }

  @override
  Future<void> deletePulsar(int id) {
    // TODO: implement deletePulsar
    throw UnimplementedError();
  }

  @override
  Future<List<PulsarInstancePo>> pulsarInstances() async {
    return [
      new PulsarInstancePo(
          0,
          "example",
          PulsarConst.defaultHost,
          PulsarConst.defaultBrokerPort,
          PulsarConst.defaultHost,
          PulsarConst.defaultFunctionPort,
          PulsarConst.defaultEnableTls == 1,
          PulsarConst.defaultFunctionEnableTls == 1,
          PulsarConst.defaultCaFile,
          PulsarConst.defaultClientCertFile,
          PulsarConst.defaultClientKeyFile,
          PulsarConst.defaultClientKeyPassword)
    ];
  }

  @override
  Future<PulsarInstancePo?> pulsarInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new PulsarInstancePo(
        0,
        "example",
        PulsarConst.defaultHost,
        PulsarConst.defaultBrokerPort,
        PulsarConst.defaultHost,
        PulsarConst.defaultFunctionPort,
        PulsarConst.defaultEnableTls == 1,
        PulsarConst.defaultFunctionEnableTls == 1,
        PulsarConst.defaultCaFile,
        PulsarConst.defaultClientCertFile,
        PulsarConst.defaultClientKeyFile,
        PulsarConst.defaultClientKeyPassword);
  }

  @override
  Future<void> saveBookkeeper(String name, String host, int port) {
    // TODO: implement saveBookkeeper
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBookkeeper(int id) {
    // TODO: implement deleteBookkeeper
    throw UnimplementedError();
  }

  @override
  Future<List<BkInstancePo>> bookkeeperInstances() async {
    return [new BkInstancePo(0, "example", BkConst.defaultHost, BkConst.defaultPort)];
  }

  @override
  Future<BkInstancePo?> bookkeeperInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new BkInstancePo(0, "example", BkConst.defaultHost, BkConst.defaultPort);
  }

  @override
  Future<void> saveZooKeeper(String name, String host, int port) {
    // TODO: implement saveZooKeeper
    throw UnimplementedError();
  }

  @override
  Future<void> deleteZooKeeper(int id) {
    // TODO: implement deleteZooKeeper
    throw UnimplementedError();
  }

  @override
  Future<List<ZkInstancePo>> zooKeeperInstances() async {
    return [new ZkInstancePo(0, "example", ZkConst.defaultHost, ZkConst.defaultPort)];
  }

  @override
  Future<ZkInstancePo?> zooKeeperInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new ZkInstancePo(0, "example", ZkConst.defaultHost, ZkConst.defaultPort);
  }

  @override
  Future<void> saveKubernetesSsh(String name, List<SshStep> sshSteps) {
    // TODO: implement saveKubernetesSsh
    throw UnimplementedError();
  }

  @override
  Future<void> deleteKubernetes(int id) {
    // TODO: implement deleteKubernetes
    throw UnimplementedError();
  }

  @override
  Future<List<K8sInstancePo>> kubernetesInstances() async {
    return [new K8sInstancePo(0, "example")];
  }

  @override
  Future<K8sInstancePo?> kubernetesInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new K8sInstancePo(0, "example");
  }

  @override
  Future<void> saveMongo(String name, String addr, String username, String password) {
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMongo(int id) {
    throw UnimplementedError();
  }

  @override
  Future<List<MongoInstancePo>> mongoInstances() async {
    return [new MongoInstancePo(0, "example", MongoConst.defaultAddr, "", "")];
  }

  @override
  Future<MongoInstancePo?> mongoInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new MongoInstancePo(0, "example", MongoConst.defaultAddr, "", "");
  }

  @override
  Future<void> saveMysql(String name, String host, int port, String username, String password) {
    // TODO: implement saveMysql
    throw UnimplementedError();
  }

  @override
  Future<void> deleteMysql(int id) {
    // TODO: implement deleteMysql
    throw UnimplementedError();
  }

  @override
  Future<List<MysqlInstancePo>> mysqlInstances() async {
    return [
      new MysqlInstancePo(0, "example", MysqlConst.defaultHost, MysqlConst.defaultPort, MysqlConst.defaultUsername,
          MysqlConst.defaultPassword)
    ];
  }

  @override
  Future<MysqlInstancePo?> mysqlInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new MysqlInstancePo(0, "example", MysqlConst.defaultHost, MysqlConst.defaultPort, MysqlConst.defaultUsername,
        MysqlConst.defaultPassword);
  }

  @override
  Future<void> saveSql(String name, String sql) {
    // TODO: implement saveSql
    throw UnimplementedError();
  }

  @override
  Future<void> deleteSql(int id) {
    // TODO: implement deleteSql
    throw UnimplementedError();
  }

  @override
  Future<List<SqlPo>> sqlList() {
    // TODO: implement sqlList
    throw UnimplementedError();
  }

  @override
  Future<SqlPo?> sqlInstance(String name) {
    // TODO: implement sqlInstance
    throw UnimplementedError();
  }

  @override
  Future<void> saveCode(String name, String code) {
    // TODO: implement saveCode
    throw UnimplementedError();
  }

  @override
  Future<void> deleteCode(int id) {
    // TODO: implement deleteCode
    throw UnimplementedError();
  }

  @override
  Future<List<CodePo>> codeList() {
    // TODO: implement codeList
    throw UnimplementedError();
  }

  @override
  Future<CodePo?> codeInstance(String name) {
    // TODO: implement codeInstance
    throw UnimplementedError();
  }

  Future<void> saveRedis(String name, String addr, String username, String password) {
    // TODO: implement sqlInstance
    throw UnimplementedError();
  }

  Future<void> deleteRedis(int id) {
    // TODO: implement sqlInstance
    throw UnimplementedError();
  }

  Future<List<RedisInstancePo>> redisInstances() async {
    return [
      new RedisInstancePo(0, "example", RedisConst.defaultIp, RedisConst.defaultPort, RedisConst.defaultPassword)
    ];
  }

  Future<RedisInstancePo?> redisInstance(String name) async {
    if (name != "example") {
      return null;
    }
    return new RedisInstancePo(0, "example", RedisConst.defaultIp, RedisConst.defaultPort, RedisConst.defaultPassword);
  }

  @override
  Future<void> updatePulsar(
      int id,
      String name,
      String host,
      int port,
      String functionHost,
      int functionPort,
      bool enableTls,
      bool functionEnableTls,
      String caFile,
      String clientCertFile,
      String clientKeyFile,
      String clientKeyPassword) {
    // TODO: implement updatePulsar
    throw UnimplementedError();
  }
}
