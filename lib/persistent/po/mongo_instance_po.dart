class MongoInstancePo {
  final int id;
  final String name;
  final String addr;
  final String username;
  final String password;

  MongoInstancePo(this.id, this.name, this.addr, this.username, this.password);

  MongoInstancePo deepCopy() {
    return new MongoInstancePo(id, name, addr, username, password);
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
    return 'MongoInstance{id: $id, name: $name}';
  }
}
