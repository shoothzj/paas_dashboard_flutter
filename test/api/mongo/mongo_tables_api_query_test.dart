import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/mongo/mongo_tables_api.dart';
import 'package:paas_dashboard_flutter/module/mongo/const.dart';

void main() {
  test("test_query_tables", () async {
    var list = await MongoTablesApi.getTableList(
        MongoConst.defaultAddr, "", "", "admin");
    print(list);
  });
}
