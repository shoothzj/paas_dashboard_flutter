import 'package:paas_dashboard_flutter/api/pulsar/pulsar_source_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_source.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class PulsarSourceBasicViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final SourceResp sourceResp;
  String topicName = "";
  Map configs = {};
  String archive = "";

  PulsarSourceBasicViewModel(this.pulsarInstancePo, this.tenantResp,
      this.namespaceResp, this.sourceResp);

  PulsarSourceBasicViewModel deepCopy() {
    return new PulsarSourceBasicViewModel(pulsarInstancePo.deepCopy(),
        tenantResp.deepCopy(), namespaceResp.deepCopy(), sourceResp.deepCopy());
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

  String get sourceName {
    return this.sourceResp.sourceName;
  }

  Future<void> fetch() async {
    try {
      final SourceConfigResp sourceConfigResp = await PulsarSourceApi.getSource(
          host, port, tenant, namespace, sourceName);
      this.topicName = sourceConfigResp.topicName;
      this.configs = sourceConfigResp.configs;
      this.archive = sourceConfigResp.archive;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }
}
