import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_view_model.dart';

class PulsarPartitionedTopicListViewModel
    extends BaseLoadListPageViewModel<PulsarPartitionedTopicViewModel> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;

  PulsarPartitionedTopicListViewModel(
      this.pulsarInstancePo, this.tenantResp, this.namespaceResp);

  PulsarPartitionedTopicListViewModel deepCopy() {
    return new PulsarPartitionedTopicListViewModel(pulsarInstancePo.deepCopy(),
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

  Future<void> fetchTopics() async {
    try {
      final results = await PulsarPartitionedTopicApi.getTopics(
          host, port, tenant, namespace);
      this.fullList = results
          .map((e) => PulsarPartitionedTopicViewModel(
          pulsarInstancePo, tenantResp, namespaceResp, e))
          .toList();
      this.displayList = this.fullList;
      loadSuccess();
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
          .where((element) => element.topic.contains(str))
          .toList();
    }
    notifyListeners();
  }

  Future<void> createPartitionedTopic(String topic, int partition) async {
    try {
      await PulsarPartitionedTopicApi.createPartitionTopic(
          host, port, tenant, namespace, topic, partition);
      await fetchTopics();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deletePartitionedTopic(String topic) async {
    try {
      await PulsarPartitionedTopicApi.deletePartitionTopic(
          host, port, tenant, namespace, topic);
      await fetchTopics();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
