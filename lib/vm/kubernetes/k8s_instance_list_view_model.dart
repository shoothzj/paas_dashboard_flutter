import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';

import 'k8s_instance_view_model.dart';

class K8sInstanceListViewModel extends ChangeNotifier {
  List<K8sInstanceViewModel> instances = <K8sInstanceViewModel>[];

  Future<void> fetchBkInstances() async {
    final results = await Persistent.kubernetesInstances();
    this.instances = results.map((e) => K8sInstanceViewModel(e)).toList();
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
