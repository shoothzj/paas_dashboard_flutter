import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

class PulsarInstanceViewModel {
  final PulsarInstancePo pulsarInstancePo;

  PulsarInstanceViewModel(this.pulsarInstancePo);

  int get id {
    return this.pulsarInstancePo.id;
  }

  String get name {
    return this.pulsarInstancePo.name;
  }

  String get host {
    return this.pulsarInstancePo.host;
  }

  int get port {
    return this.pulsarInstancePo.port;
  }
}
