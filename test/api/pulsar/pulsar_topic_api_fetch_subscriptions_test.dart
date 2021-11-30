import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';

void main() {
  test("test_fetch_subscriptions", () async {
    var subscription = await PulsarTopicAPi.getSubscription("localhost", 8080, "public", "default", "test_fetch_topic");
    print(subscription);
  });
}
