import 'dart:developer';

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';

class PulsarInstanceViewModel
    extends BaseLoadListViewModel<PulsarTenantViewModel> {
  final PulsarInstancePo pulsarInstancePo;

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
      this.fullList = results
          .map((e) => PulsarTenantViewModel(pulsarInstancePo, e))
          .toList();
      this.displayList = this.fullList;
      loadException = null;
      loading = false;
    } on Exception catch (e) {
      log('request failed, $e');
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> filter(String str) async {
    if (str == "") {
      this.displayList = this.fullList;
      notifyListeners();
      return;
    }
    if (!loading && loadException == null) {
      this.displayList = this
          .fullList
          .where((element) => element.tenantName.contains(str))
          .toList();
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
