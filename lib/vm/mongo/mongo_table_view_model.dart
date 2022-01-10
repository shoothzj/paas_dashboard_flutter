import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_database.dart';
import 'package:paas_dashboard_flutter/module/mongo/mongo_table.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';

class MongoTableViewModel extends ChangeNotifier {
  final MongoInstancePo mongoInstancePo;
  final DatabaseResp databaseResp;
  final TableResp tableResp;

  MongoTableViewModel(this.mongoInstancePo, this.databaseResp, this.tableResp);

  MongoTableViewModel deepCopy() {
    return new MongoTableViewModel(mongoInstancePo.deepCopy(),
        databaseResp.deepCopy(), tableResp.deepCopy());
  }

  String get name {
    return mongoInstancePo.name;
  }

  String get databaseName {
    return databaseResp.databaseName;
  }

  String get tableName {
    return tableResp.tableName;
  }
}
