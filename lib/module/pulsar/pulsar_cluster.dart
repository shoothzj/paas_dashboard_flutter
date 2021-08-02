class ClusterResp {
  final String instance;
  final String isLeader;
  final String version;

  ClusterResp(this.instance, this.isLeader, this.version);

  ClusterResp deepCopy() {
    return new ClusterResp(instance, isLeader, version);
  }
}
