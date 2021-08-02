class ClusterResp {
  final String instance;
  final String version;

  ClusterResp(this.instance, this.version);

  ClusterResp deepCopy() {
    return new ClusterResp(instance, version);
  }
}
