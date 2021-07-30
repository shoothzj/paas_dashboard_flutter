class HttpEndpoint {
  final String name;
  final String host;
  final int port;

  HttpEndpoint(this.name, this.host, this.port);

  @override
  String toString() {
    return 'HttpEndpoint{name: $name, host: $host, port: port}';
  }
}