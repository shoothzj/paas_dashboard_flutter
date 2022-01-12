class SqlPo {
  final int id;
  final String name;
  final String sql;

  SqlPo(this.id, this.name, this.sql);

  SqlPo deepCopy() {
    return new SqlPo(id, name, sql);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'sql': sql,
    };
  }
}
