import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_instance_view_model.dart';

class MysqlInstanceListViewModel extends ChangeNotifier {
  List<MysqlInstanceViewModel> instances = <MysqlInstanceViewModel>[];

  Future<void> fetchMongoInstances() async {
    final results = await Persistent.mysqlInstances();
    this.instances = results.map((e) => MysqlInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createMysql(String name, String host, int port, String username,
      String password) async {
    Persistent.saveMysql(name, host, port, username, password);
    fetchMongoInstances();
  }

  Future<void> deleteMysql(int id) async {
    Persistent.deleteMysql(id);
    fetchMongoInstances();
  }
}
