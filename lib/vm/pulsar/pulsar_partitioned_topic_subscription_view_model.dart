import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_subscription.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_view_model.dart';

class PulsarPartitionedTopicSubscriptionViewModel
    extends BaseLoadListViewModel<SubscriptionResp> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final TopicResp topicResp;

  PulsarPartitionedTopicSubscriptionViewModel(this.pulsarInstancePo,
      this.tenantResp, this.namespaceResp, this.topicResp);

  PulsarPartitionedTopicSubscriptionViewModel deepCopy() {
    return new PulsarPartitionedTopicSubscriptionViewModel(
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

  Future<void> fetchSubscriptions() async {
    try {
      final results = await PulsarTopicAPi.getSubscription(
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

  Future<void> clearBacklog(String subscriptionName) async {
    try {
      await PulsarTopicAPi.clearBacklog(
          host, port, tenant, namespace, topic, subscriptionName);
      await fetchSubscriptions();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
