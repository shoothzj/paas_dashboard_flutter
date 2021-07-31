import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

class PulsarInstanceViewModel extends ChangeNotifier {
  final PulsarInstancePo pulsarInstancePo;

  List<TenantResp> tenants = <TenantResp>[];

  bool loading = true;

  Exception? loadException;

  Exception? opException;

  PulsarInstanceViewModel(this.pulsarInstancePo);

  PulsarInstanceViewModel deepCopy() {
    return new PulsarInstanceViewModel(pulsarInstancePo);
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
      this.tenants = await PulsarTenantAPi.getTenants(host, port);
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
