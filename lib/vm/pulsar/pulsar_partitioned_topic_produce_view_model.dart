import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_view_model.dart';

class PulsarPartitionedTopicProduceViewModel extends BaseLoadListViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final TopicResp topicResp;

  PulsarPartitionedTopicProduceViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp, this.topicResp);

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

  String get message {
    return this.topicResp.topicName;
  }

  Future<String> sendMsg(key, value) {
    return PulsarPartitionedTopicApi.sendMsgToPartitionTopic(host, port, tenant, namespace, topic, key, value);
  }
}
