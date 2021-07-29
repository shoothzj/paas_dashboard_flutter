import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/persistent/pulsar_instance_po.dart';

class PulsarConverter {
  static PulsarInstanceContext instance2Module(PulsarInstancePo po) {
    return new PulsarInstanceContext(po.name, po.host, po.port);
  }
}