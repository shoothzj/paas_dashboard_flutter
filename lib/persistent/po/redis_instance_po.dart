class RedisInstancePo {
  final int id;
  final String name;
  final String addr;
  final String username;
  final String password;

  RedisInstancePo(this.id, this.name, this.addr, this.username, this.password);

  RedisInstancePo deepCopy() {
    return new RedisInstancePo(id, name, addr, username, password);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'addr': addr,
      'username': username,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'RedisInstance{id: $id, name: $name}';
  }
}
