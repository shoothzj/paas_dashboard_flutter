
class PulsarInstancePo {
  final int id;
  final String name;
  final String host;
  final int port;
  final String functionHost;
  final int functionPort;

  PulsarInstancePo(this.id, this.name, this.host, this.port, this.functionHost, this.functionPort);

  PulsarInstancePo deepCopy() {
    return new PulsarInstancePo(id, name, host, port, functionHost, functionPort);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'function_host': functionHost,
      'function_port': functionPort,
    };
  }

  @override
  String toString() {
    return 'PulsarInstance{id: $id, name: $name, host: $host, port: $port, functionHost: $functionHost, functionPort: $functionPort}';
  }
}
