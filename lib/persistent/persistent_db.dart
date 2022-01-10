import 'dart:developer';
import 'dart:io';

import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
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
      'INSERT INTO pulsar_instances(name, host, port, function_host, function_port) VALUES ("example", "localhost", 8080, "localhost", 8080)',
    );
    await db.execute(
      'CREATE TABLE bookkeeper_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER)',
    );
    await db.execute(
      'INSERT INTO bookkeeper_instances(name, host, port) VALUES ("example", "localhost", 8080)',
    );
    await db.execute(
      'CREATE TABLE zookeeper_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER)',
    );
    await db.execute(
      'INSERT INTO zookeeper_instances(name, host, port) VALUES ("example", "localhost", 8080)',
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
      'INSERT INTO mongo_instances(name, addr, username, password) VALUES ("example", "mongodb://localhost:27017", "", "")',
    );
    await db.execute(
      'CREATE TABLE mysql_instances(id INTEGER PRIMARY KEY, name TEXT, host TEXT, port INTEGER, username TEXT, password TEXT)',
    );
    await db.execute(
      'INSERT INTO mysql_instances(name, host, port, username, password) VALUES ("example", "localhost", 3306, "hzj", "Mysql@123")',
    );
  }

  @override
  Future<void> savePulsar(String name, String host, int port,
      String functionHost, int functionPort) async {
    var aux = await getInstance();
    var list = [name, host, port, functionHost, functionPort];
    aux.database.execute(
        'INSERT INTO pulsar_instances(name, host, port, function_host, function_port) VALUES (?, ?, ?, ?, ?)',
        list);
  }

  @override
  Future<void> deletePulsar(int id) async {
    var aux = await getInstance();
    aux.database.delete('pulsar_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<PulsarInstancePo>> pulsarInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('pulsar_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return PulsarInstancePo(aux['id'], aux['name'], aux['host'], aux['port'],
          aux['function_host'], aux['function_port']);
    });
  }

  @override
  Future<void> saveBookkeeper(String name, String host, int port) async {
    var aux = await getInstance();
    var list = [name, host, port];
    aux.database.execute(
        'INSERT INTO bookkeeper_instances(name, host, port) VALUES (?, ?, ?)',
        list);
  }

  @override
  Future<void> deleteBookkeeper(int id) async {
    var aux = await getInstance();
    aux.database
        .delete('bookkeeper_instances', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<BkInstancePo>> bookkeeperInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('bookkeeper_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return BkInstancePo(aux['id'], aux['name'], aux['host'], aux['port']);
    });
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
  Future<void> deleteMongo(int id) {
    // TODO: implement deleteMongo
    throw UnimplementedError();
  }

  @override
  Future<List<MongoInstancePo>> mongoInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('mongo_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return MongoInstancePo(aux['id'], aux['name'], aux['addr'],
          aux['username'], aux['password']);
    });
  }

  @override
  Future<void> saveMongo(
      String name, String addr, String username, String password) async {
    var aux = await getInstance();
    var list = [name, addr, username, password];
    aux.database.execute(
        'INSERT INTO mongo_instances(name, addr, username, password) VALUES (?, ?, ?, ?)',
        list);
  }

  @override
  Future<void> deleteMysql(int id) {
    // TODO: implement deleteMysql
    throw UnimplementedError();
  }

  @override
  Future<List<MysqlInstancePo>> mysqlInstances() async {
    var aux = await getInstance();
    final List<Map<String, dynamic>> maps =
        await aux.database.query('mysql_instances');
    return List.generate(maps.length, (i) {
      var aux = maps[i];
      return MysqlInstancePo(aux['id'], aux['name'], aux['host'], aux['port'],
          aux['username'], aux['password']);
    });
  }

  @override
  Future<void> saveMysql(String name, String host, int port, String username,
      String password) async {
    var aux = await getInstance();
    var list = [name, host, port, username, password];
    aux.database.execute(
        'INSERT INTO mysql_instances(name, host, port, username, password) VALUES (?, ?, ?, ?, ?)',
        list);
  }
}
