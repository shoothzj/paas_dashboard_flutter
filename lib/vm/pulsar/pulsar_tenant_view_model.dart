import 'package:paas_dashboard_flutter/api/pulsar/pulsar_namespace_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';

class PulsarTenantViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;

  List<PulsarNamespaceViewModel> namespaces = <PulsarNamespaceViewModel>[];

  PulsarTenantViewModel(this.pulsarInstancePo, this.tenantResp);

  PulsarTenantViewModel deepCopy() {
    return new PulsarTenantViewModel(
        pulsarInstancePo.deepCopy(), tenantResp.deepCopy());
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

  String get tenantName {
    return this.tenantResp.tenantName;
  }

  Future<void> fetchNamespaces() async {
    try {
      final results =
          await PulsarNamespaceAPi.getNamespaces(host, port, tenantName);
      this.namespaces = results
          .map((e) => PulsarNamespaceViewModel(pulsarInstancePo, tenantResp, e))
          .toList();
      loadException = null;
      loading = false;
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> createNamespace(String namespace) async {
    try {
      await PulsarNamespaceAPi.createNamespace(
          host, port, tenantName, namespace);
      await fetchNamespaces();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deleteNamespace(String namespace) async {
    try {
      await PulsarNamespaceAPi.deleteNamespace(
          host, port, tenantName, namespace);
      await fetchNamespaces();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
