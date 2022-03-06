//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

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

  static List<String> fieldList() {
    return ['id', 'name', 'host', 'port', 'function_host', 'function_port'];
  }

  @override
  String toString() {
    return 'PulsarInstance{id: $id, name: $name, host: $host, port: $port, functionHost: $functionHost, functionPort: $functionPort}';
  }
}
