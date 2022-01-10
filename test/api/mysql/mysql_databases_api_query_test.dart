import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/mysql/mysql_databases_api.dart';
import 'package:paas_dashboard_flutter/module/mysql/const.dart';

void main() {
  test("test_query_databases", () async {
    var list = await MysqlDatabaseApi.getDatabaseList(
        MysqlConst.defaultHost,
        MysqlConst.defaultPort,
        MysqlConst.defaultUsername,
        MysqlConst.defaultPassword);
    print(list);
  });
}
