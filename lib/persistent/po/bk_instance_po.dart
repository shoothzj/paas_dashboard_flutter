import 'package:paas_dashboard_flutter/persistent/po/http_endpoint.dart';

class BkInstancePo extends HttpEndpoint {
  final int id;

  BkInstancePo(this.id, String name, String host, int port)
      : super(name, host, port);

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
    return 'BookKeeperInstance{id: $id, name: $name, host: $host, port: port}';
  }

}
