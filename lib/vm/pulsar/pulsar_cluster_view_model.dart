import 'package:paas_dashboard_flutter/api/pulsar/pulsar_cluster_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_cluster.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';

class PulsarClusterViewModel extends BaseLoadListPageViewModel<ClusterResp> {
  List<ClusterResp> instances = <ClusterResp>[];

  final PulsarInstancePo pulsarInstancePo;

  PulsarClusterViewModel(this.pulsarInstancePo);

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

  Future<void> fetchPulsarCluster() async {
    try {
      this.fullList = await PulsarClusterAPi.cluster(host, port);
      this.displayList = this.fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> filter(String str) async {
    notifyListeners();
  }
}
