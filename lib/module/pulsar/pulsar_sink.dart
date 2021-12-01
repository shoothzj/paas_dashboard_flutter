class SinkConfigReq {
  final String name;
  final String tenant;
  final String namespace;
  final String sourceSubscriptionName;
  final List<String> inputs;
  final Map configs;
  final String archive;

  SinkConfigReq(this.tenant, this.namespace, this.name,
      this.sourceSubscriptionName, this.inputs, this.configs, this.archive);

  Map toJson() {
    Map map = new Map();
    map["name"] = this.name;
    map["tenant"] = this.tenant;
    map["namespace"] = this.namespace;
    map["sourceSubscriptionName"] = this.sourceSubscriptionName;
    map["inputs"] = this.inputs;
    map["configs"] = this.configs;
    map["archive"] = this.archive;
    return map;
  }
}

class SinkResp {
  final String sinkName;

  SinkResp(this.sinkName);

  SinkResp deepCopy() {
    return new SinkResp(this.sinkName);
  }
}

class PulsarSink {
  final String serviceUrl;

  PulsarSink(this.serviceUrl);

  Map toJson() {
    Map map = new Map();
    map["serviceUrl"] = this.serviceUrl;
    return map;
  }
}
