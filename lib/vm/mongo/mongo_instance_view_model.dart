import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';

class MongoInstanceViewModel {
  final MongoInstancePo mongoInstancePo;

  MongoInstanceViewModel(this.mongoInstancePo);

  int get id {
    return this.mongoInstancePo.id;
  }

  String get name {
    return this.mongoInstancePo.name;
  }

  String get addr {
    return this.mongoInstancePo.addr;
  }

  String get username {
    return this.mongoInstancePo.username;
  }
}
