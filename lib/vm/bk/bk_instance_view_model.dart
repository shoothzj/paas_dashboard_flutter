import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';

class BkInstanceViewModel {
  final BkInstancePo bkInstancePo;

  BkInstanceViewModel(this.bkInstancePo);

  int get id {
    return this.bkInstancePo.id;
  }

  String get name {
    return this.bkInstancePo.name;
  }

  String get host {
    return this.bkInstancePo.host;
  }

  int get port {
    return this.bkInstancePo.port;
  }

}