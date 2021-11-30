class SinkResp {
  final String sinkName;

  SinkResp(this.sinkName);

  SinkResp deepCopy() {
    return new SinkResp(this.sinkName);
  }
}
