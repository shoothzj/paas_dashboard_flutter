class MysqlInstancePo {
  final int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;

  MysqlInstancePo(
      this.id, this.name, this.host, this.port, this.username, this.password);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'MysqlInstance{id: $id, name: $name}';
  }
}
