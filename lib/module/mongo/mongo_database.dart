class DatabaseResp {
  final String databaseName;

  DatabaseResp(this.databaseName);

  DatabaseResp deepCopy() {
    return new DatabaseResp(this.databaseName);
  }

  @override
  String toString() {
    return 'DatabaseResp{databaseName: $databaseName}';
  }
}
