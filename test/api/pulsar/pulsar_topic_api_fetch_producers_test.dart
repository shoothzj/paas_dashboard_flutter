import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';

void main() {
  test("test_fetch_producers", () async {
    var producers = await PulsarTopicApi.getProducers("localhost", 8080, "public", "default", "test_fetch_topic");
    print(producers);
  });
}
