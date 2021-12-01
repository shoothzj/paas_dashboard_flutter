class SourceConfigReq {
  final String name;
  final String tenant;
  final String namespace;
  final String topicName;
  final Map configs;
  final String archive;

  SourceConfigReq(this.name, this.tenant, this.namespace, this.topicName,
      this.configs, this.archive);

  Map toJson() {
    Map map = new Map();
    map["name"] = this.name;
    map["tenant"] = this.tenant;
    map["namespace"] = this.namespace;
    map["topicName"] = this.topicName;
    map["configs"] = this.configs;
    map["archive"] = this.archive;
    return map;
  }
}

class SourceResp {
  final String sourceName;

  SourceResp(this.sourceName);

  SourceResp deepCopy() {
    return new SourceResp(this.sourceName);
  }
}
