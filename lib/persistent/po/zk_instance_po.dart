import 'package:paas_dashboard_flutter/persistent/po/http_endpoint.dart';

class ZkInstancePo extends HttpEndpoint {
  final int id;

  ZkInstancePo(this.id, String name, String host, int port) : super(name, host, port);

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
    return 'ZooKeeperInstance{id: $id, name: $name, host: $host, port: $port}';
  }
}
