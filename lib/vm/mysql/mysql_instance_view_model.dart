import 'package:paas_dashboard_flutter/persistent/po/mysql_instance_po.dart';

class MysqlInstanceViewModel {
  final MysqlInstancePo mysqlInstancePo;

  MysqlInstanceViewModel(this.mysqlInstancePo);

  int get id {
    return this.mysqlInstancePo.id;
  }

  String get name {
    return this.mysqlInstancePo.name;
  }

  String get host {
    return this.mysqlInstancePo.host;
  }

  int get port {
    return this.mysqlInstancePo.port;
  }

  String get username {
    return this.mysqlInstancePo.username;
  }
}
