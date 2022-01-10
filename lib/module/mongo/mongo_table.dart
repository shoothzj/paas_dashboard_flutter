class TableResp {
  final String tableName;

  TableResp(this.tableName);

  TableResp deepCopy() {
    return new TableResp(this.tableName);
  }

  @override
  String toString() {
    return 'TableResp{tableName: $tableName}';
  }
}
