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

import 'package:paas_dashboard_flutter/persistent/po/http_endpoint.dart';

class BkInstancePo extends HttpEndpoint {
  final int id;

  BkInstancePo(this.id, String name, String host, int port) : super(name, host, port);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
    };
  }

  static List<String> fieldList() {
    return ['id', 'name', 'host', 'port'];
  }

  @override
  String toString() {
    return 'BookKeeperInstance{id: $id, name: $name, host: $host, port: $port}';
  }
}
