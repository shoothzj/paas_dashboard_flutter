import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/mysql/mysql_tables_api.dart';
import 'package:paas_dashboard_flutter/module/mysql/const.dart';

void main() {
  test("test_query_tables", () async {
    var list = await MysqlTablesApi.getTableList(
        MysqlConst.defaultHost,
        MysqlConst.defaultPort,
        MysqlConst.defaultUsername,
        MysqlConst.defaultPassword,
        MysqlConst.infoDb);
    print(list);
  });
}
