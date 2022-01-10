import 'package:flutter_test/flutter_test.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/const.dart';

void main() {
  test("test_fetch_subscriptions", () async {
    var subscription = await PulsarTopicApi.getSubscription(
        PulsarConst.defaultHost, PulsarConst.defaultBrokerPort, "public", "default", "test_fetch_topic");
    print(subscription);
  });
}
