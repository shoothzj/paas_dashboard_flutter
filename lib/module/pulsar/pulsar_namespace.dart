class NamespaceResp {
  final String namespace;

  NamespaceResp(this.namespace);

  NamespaceResp deepCopy() {
    return new NamespaceResp(namespace);
  }

  factory NamespaceResp.fromJson(String name) {
    var split = name.split("/");
    return NamespaceResp(split[split.length - 1]);
  }
}

class BacklogQuotaReq {
  final int limitSize;
  final int? limitTime;
  final String policy;

  BacklogQuotaReq(this.limitSize, this.limitTime, this.policy);

  Map toJson() {
    Map map = new Map();
    map["limitSize"] = this.limitSize;
    if (limitTime != null) {
      map["limitTime"] = this.limitTime!;
    }
    map["policy"] = this.policy;
    return map;
  }
}

class TopicAutoCreateReq {
  final bool? allowAutoTopicCreation;
  final String? topicType;
  final int? defaultNumPartitions;

  TopicAutoCreateReq(this.allowAutoTopicCreation, this.topicType, this.defaultNumPartitions);

  Map toJson() {
    Map map = new Map();
    map["allowAutoTopicCreation"] = this.allowAutoTopicCreation;
    if (topicType != null) {
      map["topicType"] = this.topicType!;
    }
    map["defaultNumPartitions"] = this.defaultNumPartitions;
    return map;
  }
}

class MaxProducersPerTopicReq {
  int? maxProducersPerTopic;

  MaxProducersPerTopicReq(this.maxProducersPerTopic);

  Map toJson() {
    Map map = new Map();
    map["maxProducersPerTopic"] = this.maxProducersPerTopic;
    return map;
  }
}

class BacklogQuotaResp {
  final int? limitSize;
  final int? limitTime;
  final String? policy;

  BacklogQuotaResp(this.limitSize, this.limitTime, this.policy);

  factory BacklogQuotaResp.fromJson(Map map) {
    return BacklogQuotaResp(map["limitSize"], map["limitTime"], map["policy"]);
  }
}

class PolicyResp {
  final bool? isAllowAutoTopicCreation;
  final String? topicType;
  final int? defaultNumPartitions;
  final List<dynamic>? boundaries;
  final int numBundles;
  final int? messageTTLInSeconds;
  final int? maxProducersPerTopic;
  final int? maxConsumersPerTopic;
  final int? maxConsumersPerSubscription;
  final int? maxUnackedMessagesPerConsumer;
  final int? maxUnackedMessagesPerSubscription;
  final int? maxSubscriptionsPerTopic;
  final int? maxTopicsPerNamespace;

  PolicyResp(
      this.isAllowAutoTopicCreation,
      this.topicType,
      this.defaultNumPartitions,
      this.boundaries,
      this.numBundles,
      this.messageTTLInSeconds,
      this.maxProducersPerTopic,
      this.maxConsumersPerTopic,
      this.maxConsumersPerSubscription,
      this.maxUnackedMessagesPerConsumer,
      this.maxUnackedMessagesPerSubscription,
      this.maxSubscriptionsPerTopic,
      this.maxTopicsPerNamespace);

  factory PolicyResp.fromJson(Map map) {
    var autoTopicCreate = map["autoTopicCreationOverride"];
    var isAllowAutoTopicCreation;
    var topicType;
    var defaultNumPartitions;
    if (autoTopicCreate != null) {
      isAllowAutoTopicCreation = autoTopicCreate["allowAutoTopicCreation"];
      topicType = autoTopicCreate["topicType"];
      defaultNumPartitions = autoTopicCreate["defaultNumPartitions"];
    }
    var bundleData = map["bundles"];
    var boundaries;
    var numBundles;
    if (bundleData != null) {
      boundaries = bundleData["boundaries"];
      numBundles = bundleData["numBundles"];
    }
    return PolicyResp(
        isAllowAutoTopicCreation,
        topicType,
        defaultNumPartitions,
        boundaries,
        numBundles,
        map["message_ttl_in_seconds"],
        map["max_producers_per_topic"],
        map["max_consumers_per_topic"],
        map["max_consumers_per_subscription"],
        map["max_unacked_messages_per_consumer"],
        map["max_unacked_messages_per_subscription"],
        map["max_subscriptions_per_topic"],
        map["max_topics_per_namespace"]);
  }
}

class AutoTopicCreation {
  bool? isAllowAutoTopicCreation;
  String? topicType;
  int? defaultNumPartitions;

  AutoTopicCreation(this.isAllowAutoTopicCreation, this.topicType, this.defaultNumPartitions);
}

class BundlesData {
  List<String>? boundaries;
  int? numBundles;
}
