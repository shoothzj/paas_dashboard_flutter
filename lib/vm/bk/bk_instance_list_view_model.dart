import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_view_model.dart';

class BkInstanceListViewModel extends ChangeNotifier {
  List<BkInstanceViewModel> instances = <BkInstanceViewModel>[];

  Future<void> fetchBkInstances() async {
    final results = await Persistent.bookkeeperInstances();
    this.instances = results.map((e) => BkInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createBk(String name, String host, int port) async {
    Persistent.saveBookkeeper(name, host, port);
    fetchBkInstances();
  }

  Future<void> deleteBk(int id) async {
    Persistent.deleteBookkeeper(id);
    fetchBkInstances();
  }

}
