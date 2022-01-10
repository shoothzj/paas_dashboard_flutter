import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_sink_api.dart';

void main() {
  test("test_create_sink", () async {
    var list =
        await PulsarSinkApi.getSinkList("localhost", 8080, "public", "default");
    print(list);
  });
}
