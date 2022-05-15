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

import 'package:paas_dashboard_flutter/api/tls_context.dart';

class PulsarInstancePo {
  final int id;
  final String name;
  final String host;
  final int port;
  final String functionHost;
  final int functionPort;
  final bool enableTls;
  final bool functionEnableTls;
  final String caFile;
  final String clientCertFile;
  final String clientKeyFile;
  final String clientKeyPassword;

  PulsarInstancePo(this.id, this.name, this.host, this.port, this.functionHost, this.functionPort, this.enableTls,
      this.functionEnableTls, this.caFile, this.clientCertFile, this.clientKeyFile, this.clientKeyPassword);

  PulsarInstancePo deepCopy() {
    return new PulsarInstancePo(id, name, host, port, functionHost, functionPort, enableTls, functionEnableTls, caFile,
        clientCertFile, clientKeyFile, clientKeyPassword);
  }

  TlsContext createTlsContext() {
    return new TlsContext(this.enableTls, this.caFile, this.clientCertFile, this.clientKeyFile, this.clientKeyPassword);
  }

  TlsContext createFunctionTlsContext() {
    return new TlsContext(
        this.functionEnableTls, this.caFile, this.clientCertFile, this.clientKeyFile, this.clientKeyPassword);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'function_host': functionHost,
      'function_port': functionPort,
      'enable_tls': enableTls,
      'function_enable_tls': functionEnableTls,
      'ca_file': caFile,
      'client_cert_file': clientCertFile,
      'client_key_file': clientKeyFile,
      'client_key_password': clientKeyPassword,
    };
  }

  static List<String> fieldList() {
    return [
      'id',
      'name',
      'host',
      'port',
      'function_host',
      'function_port',
      'enable_tls',
      'function_enable_tls',
      'ca_file',
      'client_cert_file',
      'client_key_file',
      'client_key_password'
    ];
  }

  @override
  String toString() {
    return 'PulsarInstance{id: $id, name: $name, host: $host, port: $port, functionHost: $functionHost, functionPort: $functionPort, enableTls: $enableTls, functionEnableTls: $functionEnableTls, caFile: $caFile, clientCertFile: $clientCertFile, clientKeyFile: $clientKeyFile, clientKeyPassword: $clientKeyPassword}';
  }
}
