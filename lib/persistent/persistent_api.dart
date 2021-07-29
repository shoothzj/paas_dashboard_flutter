import 'package:paas_dashboard_flutter/persistent/pulsar_instance_po.dart';

abstract class PersistentApi {
  Future<void> savePulsar(String name, String host, int port);

  Future<void> deletePulsar(int id);

  Future<List<PulsarInstancePo>> pulsarInstances();
}
