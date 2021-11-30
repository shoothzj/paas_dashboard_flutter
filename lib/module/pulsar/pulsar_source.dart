class SourceResp {
  final String sourceName;

  SourceResp(this.sourceName);

  SourceResp deepCopy() {
    return new SourceResp(this.sourceName);
  }
}
