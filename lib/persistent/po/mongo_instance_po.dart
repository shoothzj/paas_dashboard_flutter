class MongoInstancePo {
  final int id;
  final String name;
  final String addr;
  final String username;
  final String password;

  MongoInstancePo(this.id, this.name, this.addr, this.username, this.password);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  @override
  String toString() {
    return 'MongoInstance{id: $id, name: $name}';
  }
}
