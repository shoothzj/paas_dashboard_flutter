import 'package:paas_dashboard_flutter/api/pulsar/pulsar_namespace_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class PulsarNamespaceBacklogQuotaViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  int limitSize = -1;
  int limitTime = -1;
  String retentionPolicy = "unset";

  PulsarNamespaceBacklogQuotaViewModel(
      this.pulsarInstancePo, this.tenantResp, this.namespaceResp);

  PulsarNamespaceBacklogQuotaViewModel deepCopy() {
    return new PulsarNamespaceBacklogQuotaViewModel(pulsarInstancePo.deepCopy(),
        tenantResp.deepCopy(), namespaceResp.deepCopy());
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

  String get namespace {
    return this.namespaceResp.namespace;
  }

  Future<void> fetchBacklogQuota() async {
    try {
      final BacklogQuotaResp resp = await PulsarNamespaceApi.getBacklogQuota(
          host, port, tenant, namespace);
      this.limitSize = resp.limitSize == null ? -1 : resp.limitSize!;
      this.limitTime = resp.limitTime == null ? -1 : resp.limitTime!;
      this.retentionPolicy = resp.policy == null ? "null" : resp.policy!;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> updateBacklogQuota(
      String limit, String limitTime, String policy) async {
    try {
      if (limitTime == "") {
        await PulsarNamespaceApi.updateBacklogQuota(
            host, port, tenant, namespace, int.parse(limit), null, policy);
      } else {
        await PulsarNamespaceApi.updateBacklogQuota(host, port, tenant,
            namespace, int.parse(limit), int.parse(limitTime), policy);
      }
      await fetchBacklogQuota();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
