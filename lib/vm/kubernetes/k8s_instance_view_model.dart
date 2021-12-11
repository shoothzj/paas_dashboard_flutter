import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';

class K8sInstanceViewModel {
  final K8sInstancePo k8sInstancePo;

  K8sInstanceViewModel(this.k8sInstancePo);

  int get id {
    return this.k8sInstancePo.id;
  }

  String get name {
    return this.k8sInstancePo.name;
  }
}
