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

import 'dart:developer';
import 'dart:io';

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
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class PersistentDb implements PersistentApi {
  static PersistentDb? _dbProvider;

  final Database database;

  PersistentDb(this.database);

  static Future<PersistentDb> getInstance() async {
    if (_dbProvider != null) {
      return _dbProvider!;
    }
    if (Platform.isWindows || Platform.isLinux) {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory
      databaseFactory = databaseFactoryFfi;
    }
    var dbPath = await getDatabasesPath();
    log('dbPath: $dbPath');
    Database database = await openDatabase(
      // Set the path to the database. Note: Using the `join` function from the
      // `path` package is best practice to ensure the path is correctly
      // constructed for each platform.
      join(dbPath, 'paas.db'),
      // When the database is first created, create a table to store dogs.
      onCreate: (db, version) {
        // Run the CREATE TABLE statement on the database.
        return initTable(db);
      },
      // Set the version. This executes the onCreate function and provides a
      // path to perform database upgrades and downgrades.
      version: 1,
    );
    _dbProvider = new PersistentDb(database);
    return _dbProvider!;
  }

  static initTable(Database db) async {
    log('init tables start');
    await db.execute(
      'CREATE TABLE pulsar_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER, function_host TEXT, function_port INTEGER)',
    );
    await db.execute(
      'INSERT INTO pulsar_instances(name, host, port, function_host, function_port) VALUES ("example", "${PulsarConst.defaultHost}", ${PulsarConst.defaultBrokerPort}, "${PulsarConst.defaultHost}", ${PulsarConst.defaultFunctionPort})',
    );
    await db.execute(
      'CREATE TABLE bookkeeper_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER)',
    );
    await db.execute(
      'INSERT INTO bookkeeper_instances(name, host, port) VALUES ("example", "${BkConst.defaultHost}", ${BkConst.defaultPort})',
    );
    await db.execute(
      'CREATE TABLE zookeeper_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER)',
    );
    await db.execute(
      'INSERT INTO zookeeper_instances(name, host, port) VALUES ("example", "${ZkConst.defaultHost}", ${ZkConst.defaultPort})',
    );
    // type: api、host
    await db.execute(
      'CREATE TABLE kubernetes_instances(id INTEGER PRIMARY KEY, name TEXT, type TEXT, content TEXT)',
    );
    await db.execute(
      'INSERT INTO kubernetes_instances(name, type, content) VALUES ("example", "host", "{}")',
    );
    await db.execute(
      'CREATE TABLE mongo_instances(id INTEGER PRIMARY KEY, name TEXT, addr TEXT, username TEXT, password TEXT)',
    );
    await db.execute(
      'INSERT INTO mongo_instances(name, addr, username, password) VALUES ("example", "${MongoConst.defaultAddr}", "", "")',
    );
    await db.execute(
      'CREATE TABLE mysql_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER, username TEXT, password TEXT)',
    );
    await db.execute(
      'INSERT INTO mysql_instances(name, host, port, username, password) VALUES ("example", "${MysqlConst.defaultHost}", ${MysqlConst.defaultPort}, "${MysqlConst.defaultUsername}", "${MysqlConst.defaultPassword}")',
    );
    await db.execute(
      'CREATE TABLE sql_list(id INTEGER PRIMARY KEY, name TEXT, sql TEXT)',
    );
    await db.execute(
      'CREATE TABLE code_list(id INTEGER PRIMARY KEY, name TEXT, code TEXT)',
    );
    await db.execute(
      'CREATE TABLE redis_instances(id INTEGER PRIMARY KEY, name TEXT, addr TEXT, username TEXT, password TEXT)',
    );
    await db.execute(
      'INSERT INTO redis_instances(name, addr, username, password) VALUES ("example", "${RedisConst.defaultAddr}", "${RedisConst.defaultUsername}", "${RedisConst.defaultPassword}")',
    );
  }

  @override
  Future<void> savePulsar(String name, String host, int port, String functionHost, int functionPort) async {
    var aux = await getInstance();
    var list = [name, host, port, functionHost, functionPort];
    aux.database.execute(
        'INSERT INTO pulsar_instances(name, host, port, function_host, function_port) VALUES (?, ?, ?, ?, ?)', list);
  }

  @override
  Future<void> deletePulsar(int id) async {
    var aux = await getInstance();
    aux.database.delete('pulsar_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<PulsarInstancePo>> pulsarInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('pulsar_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return PulsarInstancePo(
          aux['id'], aux['name'], aux['host'], aux['port'], aux['function_host'], aux['function_port']);
    });
  }

  @override
  Future<PulsarInstancePo?> pulsarInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('pulsar_instances', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return PulsarInstancePo(current['id'], current['name'], current['host'], current['port'], current['function_host'],
        current['function_port']);
  }

  @override
  Future<void> saveBookkeeper(String name, String host, int port) async {
    var aux = await getInstance();
    var list = [name, host, port];
    aux.database.execute('INSERT INTO bookkeeper_instances(name, host, port) VALUES (?, ?, ?)', list);
  }

  @override
  Future<void> deleteBookkeeper(int id) async {
    var aux = await getInstance();
    aux.database.delete('bookkeeper_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<BkInstancePo>> bookkeeperInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('bookkeeper_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return BkInstancePo(aux['id'], aux['name'], aux['host'], aux['port']);
    });
  }

  @override
  Future<BkInstancePo?> bookkeeperInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('pulsar_instances', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return BkInstancePo(current['id'], current['name'], current['host'], current['port']);
  }

  @override
  Future<void> saveZooKeeper(String name, String host, int port) async {
    var aux = await getInstance();
    var list = [name, host, port];
    aux.database.execute('INSERT INTO zookeeper_instances(name, host, port) VALUES (?, ?, ?)', list);
  }

  @override
  Future<void> deleteZooKeeper(int id) async {
    var aux = await getInstance();
    aux.database.delete('zookeeper_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<ZkInstancePo>> zooKeeperInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('zookeeper_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return ZkInstancePo(aux['id'], aux['name'], aux['host'], aux['port']);
    });
  }

  @override
  Future<ZkInstancePo?> zooKeeperInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('zookeeper_instances', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return ZkInstancePo(current['id'], current['name'], current['host'], current['port']);
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
  Future<List<K8sInstancePo>> kubernetesInstances() {
    // TODO: implement k8sInstances
    throw UnimplementedError();
  }

  @override
  Future<K8sInstancePo?> kubernetesInstance(String name) {
    // TODO: implement kubernetesInstance
    throw UnimplementedError();
  }

  @override
  Future<void> saveMongo(String name, String addr, String username, String password) async {
    var aux = await getInstance();
    var list = [name, addr, username, password];
    aux.database.execute('INSERT INTO mongo_instances(name, addr, username, password) VALUES (?, ?, ?, ?)', list);
  }

  @override
  Future<void> deleteMongo(int id) async {
    var aux = await getInstance();
    aux.database.delete('mongo_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<MongoInstancePo>> mongoInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('mongo_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return MongoInstancePo(aux['id'], aux['name'], aux['addr'], aux['username'], aux['password']);
    });
  }

  @override
  Future<MongoInstancePo?> mongoInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('mongo_instances', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return MongoInstancePo(current['id'], current['name'], current['addr'], current['username'], current['password']);
  }

  @override
  Future<void> saveMysql(String name, String host, int port, String username, String password) async {
    var aux = await getInstance();
    var list = [name, host, port, username, password];
    aux.database
        .execute('INSERT INTO mysql_instances(name, host, port, username, password) VALUES (?, ?, ?, ?, ?)', list);
  }

  @override
  Future<void> deleteMysql(int id) async {
    var aux = await getInstance();
    aux.database.delete('mysql_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<MysqlInstancePo>> mysqlInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('mysql_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return MysqlInstancePo(aux['id'], aux['name'], aux['host'], aux['port'], aux['username'], aux['password']);
    });
  }

  @override
  Future<MysqlInstancePo?> mysqlInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('mysql_instances', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return MysqlInstancePo(
        current['id'], current['name'], current['host'], current['port'], current['username'], current['password']);
  }

  @override
  Future<void> saveSql(String name, String sql) async {
    var aux = await getInstance();
    var list = [name, sql];
    aux.database.execute('INSERT INTO sql_list(name, sql) VALUES (?, ?)', list);
  }

  @override
  Future<void> deleteSql(int id) async {
    var aux = await getInstance();
    aux.database.delete('sql_list', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<SqlPo>> sqlList() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('sql_list');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return SqlPo(aux['id'], aux['name'], aux['sql']);
    });
  }

  @override
  Future<SqlPo?> sqlInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('sql_list', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return SqlPo(current['id'], current['name'], current['sql']);
  }

  @override
  Future<void> saveCode(String name, String code) async {
    var aux = await getInstance();
    var list = [name, code];
    aux.database.execute('INSERT INTO code_list(name, code) VALUES (?, ?)', list);
  }

  @override
  Future<void> deleteCode(int id) async {
    var aux = await getInstance();
    aux.database.delete('code_list', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<CodePo>> codeList() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('code_list');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return CodePo(aux['id'], aux['name'], aux['code']);
    });
  }

  @override
  Future<CodePo?> codeInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('code_list', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return CodePo(current['id'], current['name'], current['code']);
  }

  @override
  Future<void> saveRedis(String name, String addr, String username, String password) async {
    var aux = await getInstance();
    var list = [name, addr, username, password];
    aux.database.execute('INSERT INTO redis_instances(name, addr, username, password) VALUES (?, ?, ?, ?)', list);
  }

  @override
  Future<void> deleteRedis(int id) async {
    var aux = await getInstance();
    aux.database.delete('redis_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<RedisInstancePo>> redisInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps = await aux.database.query('redis_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return RedisInstancePo(aux['id'], aux['name'], aux['addr'], aux['username'], aux['password']);
    });
  }

  @override
  Future<RedisInstancePo?> redisInstance(String name) async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('redis_instances', where: "name = ?", whereArgs: [name]);
    if (maps.length == 0) {
      return null;
    }
    var current = maps[0];
    return RedisInstancePo(current['id'], current['name'], current['addr'], current['username'], current['password']);
  }
}
