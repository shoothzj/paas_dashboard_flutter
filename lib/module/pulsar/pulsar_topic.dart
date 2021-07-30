import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';

class PulsarTopicModule {
  final String topicName;

  PulsarTopicModule(this.topicName);
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
