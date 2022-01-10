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

class BacklogQuotaResp {
  final int? limitSize;
  final int? limitTime;
  final String? policy;

  BacklogQuotaResp(this.limitSize, this.limitTime, this.policy);

  factory BacklogQuotaResp.fromJson(Map map) {
    return BacklogQuotaResp(map["limitSize"], map["limitTime"], map["policy"]);
  }
}
