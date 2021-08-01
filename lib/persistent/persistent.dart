import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:paas_dashboard_flutter/persistent/persistent_api.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_db.dart';
import 'package:paas_dashboard_flutter/persistent/persistent_memory.dart';
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

class Persistent {
  static PersistentApi? api;

  static Future<PersistentApi> getApi() async {
    if (api == null) {
      if (!kIsWeb) {
        api = await PersistentDb.getInstance();
      } else {
        api = new PersistentMemory();
      }
    }
    return api!;
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

  static Future<void> saveBookkeeper(String name, String host, int port) async {
    return (await getApi()).saveBookkeeper(name, host, port);
  }

  static Future<void> deleteBookkeeper(int id) async {
    return (await getApi()).deleteBookkeeper(id);
  }

  static Future<List<BkInstancePo>> bookkeeperInstances() async {
    return (await getApi()).bookkeeperInstances();
  }

  static bool supportDb() {
    return !kIsWeb;
  }
}
