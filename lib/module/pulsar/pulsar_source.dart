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

class SourceConfigReq {
  final String name;
  final String tenant;
  final String namespace;
  final String topicName;
  final Map configs;
  final String archive;

  SourceConfigReq(this.name, this.tenant, this.namespace, this.topicName, this.configs, this.archive);

  Map toJson() {
    Map map = new Map();
    map["name"] = this.name;
    map["tenant"] = this.tenant;
    map["namespace"] = this.namespace;
    map["topicName"] = this.topicName;
    map["configs"] = this.configs;
    map["archive"] = this.archive;
    return map;
  }
}

class SourceConfigResp {
  final String name;
  final String tenant;
  final String namespace;
  final String topicName;
  final Map configs;
  final String archive;

  SourceConfigResp(this.name, this.tenant, this.namespace, this.topicName, this.configs, this.archive);

  factory SourceConfigResp.fromJson(Map map) {
    return SourceConfigResp(
        map["name"], map["tenant"], map["namespace"], map["topicName"], map["configs"], map["archive"]);
  }
}

class SourceResp {
  final String sourceName;

  SourceResp(this.sourceName);

  SourceResp deepCopy() {
    return new SourceResp(this.sourceName);
  }
}
