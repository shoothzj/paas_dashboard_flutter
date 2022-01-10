import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_view_model.dart';

class PulsarTopicListViewModel extends BaseLoadListPageViewModel<PulsarTopicViewModel> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;

  PulsarTopicListViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp);

  PulsarTopicListViewModel deepCopy() {
    return new PulsarTopicListViewModel(pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy());
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
      final results = await PulsarTopicApi.getTopics(host, port, tenant, namespace);
      this.fullList = results.map((e) => PulsarTopicViewModel(pulsarInstancePo, tenantResp, namespaceResp, e)).toList();
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
      this.displayList = this.fullList.where((element) => element.topic.contains(str)).toList();
    }
    notifyListeners();
  }

  Future<void> createTopic(String topic) async {
    try {
      await PulsarTopicApi.createTopic(host, port, tenant, namespace, topic);
      await fetchTopics();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deleteTopic(String topic) async {
    try {
      await PulsarTopicApi.deleteTopic(host, port, tenant, namespace, topic);
      await fetchTopics();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
