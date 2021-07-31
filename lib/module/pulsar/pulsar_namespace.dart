class NamespaceResp {
  final String namespaceName;

  NamespaceResp(this.namespaceName);

  NamespaceResp deepCopy() {
    return new NamespaceResp(namespaceName);
  }

  factory NamespaceResp.fromJson(String name) {
    var split = name.split("/");
    return NamespaceResp(split[split.length - 1]);
  }
}
