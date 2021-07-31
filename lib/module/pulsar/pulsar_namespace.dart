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
