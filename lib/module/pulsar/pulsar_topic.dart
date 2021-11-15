import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_view_model.dart';

class PulsarTopicModule {
  final String topicName;

  PulsarTopicModule(this.topicName);
}

class TopicPageContext {
  final PulsarPartitionedTopicViewModel pulsarTopicViewModel;
  final PulsarTopicModule topicModule;

  TopicPageContext(this.pulsarTopicViewModel, this.topicModule);

  String get host {
    return pulsarTopicViewModel.host;
  }

  int get port {
    return pulsarTopicViewModel.port;
  }

  String get tenant {
    return pulsarTopicViewModel.tenant;
  }

  String get namespace {
    return pulsarTopicViewModel.namespace;
  }

  String get topicName {
    return topicModule.topicName;
  }
}

class TopicResp {
  final String topicName;

  TopicResp(this.topicName);

  TopicResp deepCopy() {
    return new TopicResp(this.topicName);
  }

  factory TopicResp.fromJson(String name) {
    var split = name.split("/");
    return TopicResp(split[split.length - 1]);
  }
}
