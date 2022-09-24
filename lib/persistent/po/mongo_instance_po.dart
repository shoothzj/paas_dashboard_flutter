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

class MongoInstancePo {
  final int id;
  final String name;
  final String addr;
  final String username;
  final String password;

  MongoInstancePo(this.id, this.name, this.addr, this.username, this.password);

  MongoInstancePo deepCopy() {
    return MongoInstancePo(id, name, addr, username, password);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'addr': addr,
      'username': username,
      'password': password,
    };
  }

  static List<String> fieldList() {
    return ['id', 'name', 'addr', 'username', 'password'];
  }

  @override
  String toString() {
    return 'MongoInstance{id: $id, name: $name}';
  }
}
