import 'dart:developer';

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';

class PulsarInstanceViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;

  List<PulsarTenantViewModel> tenants = <PulsarTenantViewModel>[];

  PulsarInstanceViewModel(this.pulsarInstancePo);

  PulsarInstanceViewModel deepCopy() {
    return new PulsarInstanceViewModel(pulsarInstancePo.deepCopy());
  }

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
    try {
      final results = await PulsarTenantAPi.getTenants(host, port);
      this.tenants = results
          .map((e) => PulsarTenantViewModel(pulsarInstancePo, e))
          .toList();
      loadException = null;
      loading = false;
    } on Exception catch (e) {
      log('request failed, $e');
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> createTenant(String tenantName) async {
    try {
      await PulsarTenantAPi.createTenant(host, port, tenantName);
      await fetchTenants();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deleteTenants(String tenantName) async {
    try {
      await PulsarTenantAPi.deleteTenant(host, port, tenantName);
      await fetchTenants();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
