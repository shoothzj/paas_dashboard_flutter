import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_view_model.dart';

class MongoInstanceListViewModel extends ChangeNotifier {
  List<MongoInstanceViewModel> instances = <MongoInstanceViewModel>[];

  Future<void> fetchMongoInstances() async {
    final results = await Persistent.mongoInstances();
    this.instances = results.map((e) => MongoInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createMongo(String name, String addr, String username, String password) async {
    Persistent.saveMongo(name, addr, username, password);
    fetchMongoInstances();
  }

  Future<void> deleteMongo(int id) async {
    Persistent.deleteMongo(id);
    fetchMongoInstances();
  }
}
