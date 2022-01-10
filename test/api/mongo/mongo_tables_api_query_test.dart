import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/mongo/mongo_tables_api.dart';

void main() {
  test("test_query_tables", () async {
    var list = await MongoTablesApi.getTableList(
        "mongodb://localhost:27017", "", "", "admin");
    print(list);
  });
}
