import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_producer.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_view_model.dart';

class PulsarPartitionedTopicProducerViewModel
    extends BaseLoadListViewModel<ProducerResp> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final TopicResp topicResp;

  PulsarPartitionedTopicProducerViewModel(this.pulsarInstancePo,
      this.tenantResp, this.namespaceResp, this.topicResp);
  PulsarPartitionedTopicProducerViewModel deepCopy() {
    return new PulsarPartitionedTopicProducerViewModel(
        pulsarInstancePo.deepCopy(),
        tenantResp.deepCopy(),
        namespaceResp.deepCopy(),
        topicResp.deepCopy());
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

  String get topic {
    return this.topicResp.topicName;
  }

  Future<void> fetchProducers() async {
    try {
      final results = await PulsarPartitionedTopicApi.getProducers(
          host, port, tenant, namespace, topic);
      this.fullList = results;
      this.displayList = this.fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }
}
