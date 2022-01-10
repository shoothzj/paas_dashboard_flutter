import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/mongo/mongo_databases_api.dart';

void main() {
  test("test_query_databases", () async {
    var list = await MongoDatabaseApi.getDatabaseList(
        "mongodb://localhost:27017", "", "");
    print(list);
  });
}
