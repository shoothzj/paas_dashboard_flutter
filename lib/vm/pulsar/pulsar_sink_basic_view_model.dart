import 'package:paas_dashboard_flutter/api/pulsar/pulsar_sink_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_sink.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class PulsarSinkBasicViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final SinkResp sinkResp;
  List<dynamic> inputs = [];
  Map configs = {};
  String archive = "";

  PulsarSinkBasicViewModel(this.pulsarInstancePo, this.tenantResp,
      this.namespaceResp, this.sinkResp);

  PulsarSinkBasicViewModel deepCopy() {
    return new PulsarSinkBasicViewModel(pulsarInstancePo.deepCopy(),
        tenantResp.deepCopy(), namespaceResp.deepCopy(), sinkResp.deepCopy());
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

  String get sinkName {
    return this.sinkResp.sinkName;
  }

  Future<void> fetch() async {
    try {
      final SinkConfigResp sinkConfigResp =
          await PulsarSinkApi.getSink(host, port, tenant, namespace, sinkName);
      this.inputs = sinkConfigResp.inputs;
      this.configs = sinkConfigResp.configs;
      this.archive = sinkConfigResp.archive;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }
}
