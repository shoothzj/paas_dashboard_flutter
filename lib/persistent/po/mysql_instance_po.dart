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

class MysqlInstancePo {
  final int id;
  final String name;
  final String host;
  final int port;
  final String username;
  final String password;

  MysqlInstancePo(this.id, this.name, this.host, this.port, this.username, this.password);

  MysqlInstancePo deepCopy() {
    return MysqlInstancePo(id, name, host, port, username, password);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'host': host,
      'port': port,
      'username': username,
      'password': password,
    };
  }

  static List<String> fieldList() {
    return ['id', 'name', 'host', 'port', 'username', 'password'];
  }

  @override
  String toString() {
    return 'MysqlInstance{id: $id, name: $name}';
  }
}
