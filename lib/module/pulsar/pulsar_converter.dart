import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';

class PulsarConverter {
  static PulsarInstanceContext instance2Module(PulsarInstanceViewModel model) {
    return new PulsarInstanceContext(model.name, model.host, model.port);
  }
}
