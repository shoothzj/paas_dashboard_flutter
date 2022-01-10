import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';

class PulsarInstanceListViewModel extends ChangeNotifier {
  List<PulsarInstanceViewModel> instances = <PulsarInstanceViewModel>[];

  Future<void> fetchPulsarInstances() async {
    final results = await Persistent.pulsarInstances();
    this.instances = results.map((e) => PulsarInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createPulsar(String name, String host, int port,
      String functionHost, int functionPort) async {
    Persistent.savePulsar(name, host, port, functionHost, functionPort);
    fetchPulsarInstances();
  }

  Future<void> deletePulsar(int id) async {
    Persistent.deletePulsar(id);
    fetchPulsarInstances();
  }
}
