class RedisInstancePo {
  final int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;

  RedisInstancePo(this.id, this.name, this.host, this.port, this.username, this.password);

  RedisInstancePo deepCopy() {
    return new RedisInstancePo(id, name, host, port, username, password);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'RedisInstance{id: $id, name: $name}';
  }
}
