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

import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_view_model.dart';

class PulsarTopicModule {
  final String topicName;

  PulsarTopicModule(this.topicName);
}

class TopicPageContext {
  final PulsarPartitionedTopicViewModel pulsarTopicViewModel;
  final PulsarTopicModule topicModule;

  TopicPageContext(this.pulsarTopicViewModel, this.topicModule);

  String get host {
    return pulsarTopicViewModel.host;
  }

  int get port {
    return pulsarTopicViewModel.port;
  }

  String get tenant {
    return pulsarTopicViewModel.tenant;
  }

  String get namespace {
    return pulsarTopicViewModel.namespace;
  }

  String get topicName {
    return topicModule.topicName;
  }
}

class TopicResp {
  final String topicName;

  TopicResp(this.topicName);

  TopicResp deepCopy() {
    return new TopicResp(this.topicName);
  }

  factory TopicResp.fromJson(String name) {
    var split = name.split("/");
    return TopicResp(split[split.length - 1]);
  }
}
