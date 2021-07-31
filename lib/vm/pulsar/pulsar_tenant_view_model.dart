import 'package:paas_dashboard_flutter/api/pulsar/pulsar_namespace_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';

class PulsarTenantViewModel
    extends BaseLoadListViewModel<PulsarNamespaceViewModel> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;

  List<PulsarNamespaceViewModel> displayList = <PulsarNamespaceViewModel>[];
  List<PulsarNamespaceViewModel> fullList = <PulsarNamespaceViewModel>[];

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

  String get tenant {
    return this.tenantResp.tenant;
  }

  Future<void> fetchNamespaces() async {
    try {
      final results =
          await PulsarNamespaceAPi.getNamespaces(host, port, tenant);
      this.fullList = results
          .map((e) => PulsarNamespaceViewModel(pulsarInstancePo, tenantResp, e))
          .toList();
      this.displayList = this.fullList;
      loadException = null;
      loading = false;
    } on Exception catch (e) {
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
          .where((element) => element.namespace.contains(str))
          .toList();
    }
    notifyListeners();
  }

  Future<void> createNamespace(String namespace) async {
    try {
      await PulsarNamespaceAPi.createNamespace(host, port, tenant, namespace);
      await fetchNamespaces();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deleteNamespace(String namespace) async {
    try {
      await PulsarNamespaceAPi.deleteNamespace(host, port, tenant, namespace);
      await fetchNamespaces();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
