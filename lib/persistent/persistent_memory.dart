import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

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

  @override
  Future<void> saveBookkeeper(String name, String host, int port) {
    // TODO: implement saveBookkeeper
    throw UnimplementedError();
  }

  @override
  Future<void> deleteBookkeeper(int id) {
    // TODO: implement deleteBookkeeper
    throw UnimplementedError();
  }

  @override
  Future<List<BkInstancePo>> bookkeeperInstances() async {
    return [new BkInstancePo(0, "example", "localhost", 8080)];
  }
}
