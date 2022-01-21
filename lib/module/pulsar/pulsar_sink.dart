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

class SinkConfigReq {
  final String name;
  final String tenant;
  final String namespace;
  final String sourceSubscriptionName;
  final List<String> inputs;
  final Map configs;
  final String archive;

  SinkConfigReq(
      this.tenant, this.namespace, this.name, this.sourceSubscriptionName, this.inputs, this.configs, this.archive);

  Map toJson() {
    Map map = new Map();
    map["name"] = this.name;
    map["tenant"] = this.tenant;
    map["namespace"] = this.namespace;
    map["sourceSubscriptionName"] = this.sourceSubscriptionName;
    map["inputs"] = this.inputs;
    map["configs"] = this.configs;
    map["archive"] = this.archive;
    return map;
  }
}

class SinkConfigResp {
  final String name;
  final String tenant;
  final String namespace;
  final List<dynamic> inputs;
  final Map configs;
  final String archive;

  SinkConfigResp(this.name, this.tenant, this.namespace, this.inputs, this.configs, this.archive);

  factory SinkConfigResp.fromJson(Map map) {
    return SinkConfigResp(map["name"], map["tenant"], map["namespace"], map["inputs"], map["configs"], map["archive"]);
  }
}

class SinkResp {
  final String sinkName;

  SinkResp(this.sinkName);

  SinkResp deepCopy() {
    return new SinkResp(this.sinkName);
  }

  @override
  String toString() {
    return 'SinkResp{sinkName: $sinkName}';
  }
}

class PulsarSink {
  final String serviceUrl;

  PulsarSink(this.serviceUrl);

  Map toJson() {
    Map map = new Map();
    map["serviceUrl"] = this.serviceUrl;
    return map;
  }
}
