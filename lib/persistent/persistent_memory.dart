import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/pulsar_instance_po.dart';

class PersistentMemory implements PersistentApi {
  @override
  Future<void> savePulsar(String name, String host, int port) {
    // TODO: implement savePulsar
    throw UnimplementedError();
  }

  @override
  Future<void> deletePulsar(int id) {
    // TODO: implement deletePulsar
    throw UnimplementedError();
  }

  @override
  Future<List<PulsarInstancePo>> pulsarInstances() async {
    return [new PulsarInstancePo(0, "example", "localhost", 8080)];
  }

}
