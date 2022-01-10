import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_database.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';

class MongoDatabaseViewModel extends ChangeNotifier {
  final MongoInstancePo mongoInstancePo;
  final DatabaseResp databaseResp;

  MongoDatabaseViewModel(this.mongoInstancePo, this.databaseResp);

  MongoDatabaseViewModel deepCopy() {
    return new MongoDatabaseViewModel(
        mongoInstancePo.deepCopy(), databaseResp.deepCopy());
  }

  String get name {
    return mongoInstancePo.name;
  }

  String get databaseName {
    return databaseResp.databaseName;
  }
}
