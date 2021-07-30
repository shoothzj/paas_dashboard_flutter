import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';

class PulsarSubscriptionModule {
  final String subscriptionName;

  PulsarSubscriptionModule(this.subscriptionName);
}

class SubscriptionPageContext {
  final TopicPageContext topicPageContext;
  final PulsarSubscriptionModule subscriptionModule;

  SubscriptionPageContext(this.topicPageContext, this.subscriptionModule);

  String get host {
    return topicPageContext.host;
  }

  int get port {
    return topicPageContext.port;
  }

  String get tenantName {
    return topicPageContext.tenantName;
  }

  String get namespaceName {
    return topicPageContext.namespaceName;
  }

  String get topicName {
    return topicPageContext.topicName;
  }
}

class SubscriptionResp {
  final String subscriptionName;

  SubscriptionResp(this.subscriptionName);

  factory SubscriptionResp.fromJson(String name) {
    var split = name.split("/");
    return SubscriptionResp(split[split.length - 1]);
  }
}
