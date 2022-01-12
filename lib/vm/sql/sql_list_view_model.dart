import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/sql/sql_view_model.dart';

class SqlListViewModel extends ChangeNotifier {
  List<SqlViewModel> instances = <SqlViewModel>[];

  Future<void> fetchSqlList() async {
    final results = await Persistent.sqlList();
    this.instances = results.map((e) => SqlViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createSql(String name, String sql) async {
    Persistent.saveSql(name, sql);
    fetchSqlList();
  }

  Future<void> deleteSql(int id) async {
    Persistent.deleteSql(id);
    fetchSqlList();
  }
}
