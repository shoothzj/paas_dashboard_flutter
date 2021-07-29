import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_db.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_memory.dart';
import 'package:paas_dashboard_flutter/persistent/pulsar_instance_po.dart';

class Persistent {
  final PersistentApi persistentApi;

  Persistent(this.persistentApi);

  static Future<Persistent> getInstance() async {
    if (!kIsWeb) {
      PersistentDb aux = await PersistentDb.getInstance();
      return new Persistent(aux);
    } else {
      return new Persistent(new PersistentMemory());
    }
  }

  static Future<PersistentApi> getApi() async {
    var instance = await getInstance();
    return instance.persistentApi;
  }

  static Future<void> savePulsar(String name, String host, int port) async {
    return (await getApi()).savePulsar(name, host, port);
  }

  static Future<void> deletePulsar(int id) async {
    return (await getApi()).deletePulsar(id);
  }

  static Future<List<PulsarInstancePo>> pulsarInstances() async {
    return (await getApi()).pulsarInstances();
  }

  static bool supportDb() {
    return !kIsWeb;
  }
}
