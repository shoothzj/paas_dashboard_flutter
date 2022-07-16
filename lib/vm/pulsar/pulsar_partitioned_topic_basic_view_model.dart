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

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class PulsarPartitionedTopicBasicViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final TopicResp topicResp;
  String partitionNum = "";
  double msgRateIn = 0;
  double msgRateOut = 0;
  int msgInCounter = 0;
  int msgOutCounter = 0;
  int storageSize = 0;

  PulsarPartitionedTopicBasicViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp, this.topicResp);

  PulsarPartitionedTopicBasicViewModel deepCopy() {
    return new PulsarPartitionedTopicBasicViewModel(
        pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy(), topicResp.deepCopy());
  }

  int get id {
    return this.pulsarInstancePo.id;
  }

  String get name {
    return this.pulsarInstancePo.name;
  }

  String get host {
    return this.pulsarInstancePo.host;
  }

  int get port {
    return this.pulsarInstancePo.port;
  }

  String get tenant {
    return this.tenantResp.tenant;
  }

  String get namespace {
    return this.namespaceResp.namespace;
  }

  String get topic {
    return this.topicResp.topicName;
  }

  Future<void> fetchPartitions() async {
    try {
      final results = await PulsarPartitionedTopicApi.getBase(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, topic);
      partitionNum = results.partitionNum.toString();
      msgRateIn = results.msgRateIn;
      msgRateOut = results.msgRateOut;
      msgInCounter = results.msgInCounter;
      msgOutCounter = results.msgOutCounter;
      storageSize = results.storageSize;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> modifyTopicPartition(String topic, int partition) async {
    try {
      await PulsarPartitionedTopicApi.modifyPartitionTopic(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, topic, partition);
      await fetchPartitions();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> createMissTopicPartition(String topic) async {
    try {
      await PulsarPartitionedTopicApi.createMissPartitionTopic(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, topic);
      await fetchPartitions();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
