import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/po/sql_instance_po.dart';

class SqlViewModel extends ChangeNotifier {
  final SqlPo sqlPo;

  SqlViewModel(this.sqlPo);

  SqlViewModel deepCopy() {
    return new SqlViewModel(sqlPo.deepCopy());
  }

  int get id {
    return this.sqlPo.id;
  }

  String get name {
    return this.sqlPo.name;
  }

  String get sql {
    return this.sqlPo.sql;
  }
}
