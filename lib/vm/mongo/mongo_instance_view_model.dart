import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';

class MongoInstanceViewModel extends ChangeNotifier {
  final MongoInstancePo mongoInstancePo;

  MongoInstanceViewModel(this.mongoInstancePo);

  MongoInstanceViewModel deepCopy() {
    return new MongoInstanceViewModel(mongoInstancePo.deepCopy());
  }

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
