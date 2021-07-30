import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

class PulsarInstanceViewModel extends ChangeNotifier {
  final PulsarInstancePo pulsarInstancePo;

  List<TenantResp> tenants = <TenantResp>[];

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

  Future<void> fetchTenants() async {
    this.tenants = await PulsarTenantAPi.getTenants(host, port);
    notifyListeners();
  }
}
