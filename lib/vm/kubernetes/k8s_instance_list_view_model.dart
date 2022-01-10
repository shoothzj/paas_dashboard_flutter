import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';

import 'k8s_instance_view_model.dart';

class K8sInstanceListViewModel extends ChangeNotifier {
  List<K8sInstanceViewModel> instances = <K8sInstanceViewModel>[];

  Future<void> fetchKubernetesInstances() async {
    final results = await Persistent.kubernetesInstances();
    this.instances = results.map((e) => K8sInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createKubernetesSsh(String name, SshStep sshStep) async {
    Persistent.saveKubernetesSsh(name, [sshStep]);
    fetchKubernetesInstances();
  }

  Future<void> deleteKubernetes(int id) async {
    Persistent.deleteKubernetes(id);
    fetchKubernetesInstances();
  }
}
