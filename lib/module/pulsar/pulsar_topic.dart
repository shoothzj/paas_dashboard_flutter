import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';

class PulsarTopicModule {
  final String topicName;

  PulsarTopicModule(this.topicName);
}

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

class TopicPageContext {
  final NamespacePageContext namespacePageContext;
  final PulsarTopicModule topicModule;

  TopicPageContext(this.namespacePageContext, this.topicModule);

  String get host {
    return namespacePageContext.tenantPageContext.instanceContext.host;
  }

  int get port {
    return namespacePageContext.tenantPageContext.instanceContext.port;
  }

  String get tenantName {
    return namespacePageContext.tenantPageContext.tenantModule.tenantName;
  }

  String get namespaceName {
    return namespacePageContext.namespaceModule.namespaceName;
  }

  String get topicName {
    return topicModule.topicName;
  }
}

class TopicResp {
  final String topicName;

  TopicResp(this.topicName);

  factory TopicResp.fromJson(String name) {
    var split = name.split("/");
    return TopicResp(split[split.length - 1]);
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
