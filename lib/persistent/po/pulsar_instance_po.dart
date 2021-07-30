class PulsarInstancePo {
  final int id;
  final String name;
  final String host;
  final int port;

  PulsarInstancePo(this.id, this.name, this.host, this.port);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
    };
  }

  @override
  String toString() {
    return 'PulsarInstance{id: $id, name: $name, host: $host, port: port}';
  }
}
