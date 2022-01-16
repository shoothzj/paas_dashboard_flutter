import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/redis/redis_api.dart';

void main() {
  test("test_set_get", () async {
    await RedisApi.set("localhost", 6379, "", "", "key", "value");
    var val = await RedisApi.get("localhost", 6379, "", "", "key");
    print(val);
  });
}
