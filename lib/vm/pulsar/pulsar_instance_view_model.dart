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

import 'dart:async';
import 'dart:developer';

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_namespace_api.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/util/common_utils.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';

class PulsarInstanceViewModel extends BaseLoadListPageViewModel<PulsarTenantViewModel> {
  final PulsarInstancePo pulsarInstancePo;

  double progress = 0;

  PulsarInstanceViewModel(this.pulsarInstancePo);

  PulsarInstanceViewModel deepCopy() {
    return PulsarInstanceViewModel(pulsarInstancePo.deepCopy());
  }

  int get id {
    return pulsarInstancePo.id;
  }

  String get name {
    return pulsarInstancePo.name;
  }

  String get host {
    return pulsarInstancePo.host;
  }

  int get port {
    return pulsarInstancePo.port;
  }

  String get functionHost {
    return pulsarInstancePo.functionHost;
  }

  int get functionPort {
    return pulsarInstancePo.functionPort;
  }

  bool get enableTls {
    return pulsarInstancePo.enableTls;
  }

  bool get functionEnableTls {
    return pulsarInstancePo.functionEnableTls;
  }

  String get caFile {
    return pulsarInstancePo.caFile;
  }

  String get clientCertFile {
    return pulsarInstancePo.clientCertFile;
  }

  String get clientKeyFile {
    return pulsarInstancePo.clientKeyFile;
  }

  String get clientKeyPassword {
    return pulsarInstancePo.clientKeyPassword;
  }

  PulsarFormDto toPulsarFormDto() {
    PulsarFormDto formDto = PulsarFormDto();
    formDto.id = pulsarInstancePo.id;
    formDto.name = pulsarInstancePo.name;
    formDto.host = pulsarInstancePo.host;
    formDto.port = pulsarInstancePo.port;
    formDto.functionHost = pulsarInstancePo.functionHost;
    formDto.functionPort = pulsarInstancePo.functionPort;
    formDto.enableTls = pulsarInstancePo.enableTls;
    formDto.functionEnableTls = pulsarInstancePo.functionEnableTls;
    formDto.caFile = pulsarInstancePo.caFile;
    formDto.clientCertFile = pulsarInstancePo.clientCertFile;
    formDto.clientKeyFile = pulsarInstancePo.clientKeyFile;
    formDto.clientKeyPassword = pulsarInstancePo.clientKeyPassword;
    return formDto;
  }

  Future<void> fetchTenants() async {
    try {
      final results = await PulsarTenantApi.getTenants(id, host, port, pulsarInstancePo.createTlsContext());
      fullList = results.map((e) => PulsarTenantViewModel(pulsarInstancePo, e)).toList();
      displayList = fullList;
      progress = 0;
      loadSuccess();
    } on Exception catch (e) {
      log('request failed, $e');
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> filter(String str) async {
    if (str == "") {
      displayList = fullList;
      notifyListeners();
      return;
    }
    if (!loading && loadException == null) {
      displayList = fullList.where((element) => element.tenant.contains(str)).toList();
    }
    notifyListeners();
  }

  Future<void> createTenant(String tenant) async {
    try {
      await PulsarTenantApi.createTenant(id, host, port, pulsarInstancePo.createTlsContext(), tenant);
      await fetchTenants();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deleteTenants(String tenant) async {
    try {
      await PulsarTenantApi.deleteTenant(id, host, port, pulsarInstancePo.createTlsContext(), tenant);
      await fetchTenants();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<List<List<String>>> getAllTenant() async {
    final results = await PulsarTenantApi.getTenants(id, host, port, pulsarInstancePo.createTlsContext());
    List<List<String>> tenantData = [];
    for (var tenant in results) {
      tenantData.add([tenant.tenant]);
    }
    return tenantData;
  }

  Future<void> createAllTenant(List<dynamic> tenants) async {
    try {
      await PulsarTenantApi.createTenant(id, host, port, pulsarInstancePo.createTlsContext(), tenants[0]);
    } on Exception catch (e) {
      log('create tenant [${tenants[0]}] fail. err: $e');
      opException = e;
      notifyListeners();
    }
  }

  Future<List<List<dynamic>>> getAllNamespace(Future<List<List<dynamic>>> tenantsFuture) async {
    List<List<dynamic>> namespaceData = [];
    var tenants = await tenantsFuture;
    for (var tenant in tenants) {
      final resp =
          await PulsarNamespaceApi.getNamespaces(id, host, port, pulsarInstancePo.createTlsContext(), tenant[0]);
      for (var namespaceReq in resp) {
        final policy = await PulsarNamespaceApi.getPolicy(
            id, host, port, pulsarInstancePo.createTlsContext(), tenant[0], namespaceReq.namespace);
        final backlogQuota = await PulsarNamespaceApi.getBacklogQuota(
            id, host, port, pulsarInstancePo.createTlsContext(), tenant[0], namespaceReq.namespace);
        final retention = await PulsarNamespaceApi.getRetention(
            id, host, port, pulsarInstancePo.createTlsContext(), tenant[0], namespaceReq.namespace);
        namespaceData.add([
          tenant[0],
          namespaceReq.namespace,
          backlogQuota.policy,
          backlogQuota.limitSize,
          retention.retentionSizeInMB,
          retention.retentionTimeInMinutes,
          policy.messageTTLInSeconds
        ]);
      }
    }
    return namespaceData;
  }

  Future<List<List<dynamic>>> getAllNamespaceName(Future<List<List<dynamic>>> tenantsFuture) async {
    List<List<dynamic>> namespaceData = [];
    var tenants = await tenantsFuture;
    for (var tenant in tenants) {
      final resp =
          await PulsarNamespaceApi.getNamespaces(id, host, port, pulsarInstancePo.createTlsContext(), tenant[0]);
      for (var namespace in resp) {
        namespaceData.add([tenant[0], namespace.namespace]);
      }
    }
    return namespaceData;
  }

  Future<void> createAllNamespace(List<dynamic> namespaces) async {
    try {
      var namespaceCsv = NamespaceCsv(
          namespaces[0],
          namespaces[1],
          namespaces[2],
          int.parse(namespaces[3] == "null" ? "0" : '${namespaces[3]}'),
          int.parse(namespaces[4] == "null" ? "0" : '${namespaces[4]}'),
          int.parse(namespaces[5] == "null" ? "0" : '${namespaces[5]}'),
          int.parse(namespaces[6] == "null" ? "0" : '${namespaces[6]}'));
      await PulsarNamespaceApi.createNamespace(
          id, host, port, pulsarInstancePo.createTlsContext(), namespaceCsv.tenant, namespaceCsv.namespace);
      PulsarNamespaceApi.updateBacklogQuota(id, host, port, pulsarInstancePo.createTlsContext(), namespaceCsv.tenant,
          namespaceCsv.namespace, namespaceCsv.backlogQuotaBytes, 0, namespaceCsv.backlogPolicy);
      PulsarNamespaceApi.setMessageTTLSecond(id, host, port, pulsarInstancePo.createTlsContext(), namespaceCsv.tenant,
          namespaceCsv.namespace, namespaceCsv.ttlSeconds);
      PulsarNamespaceApi.setRetention(id, host, port, pulsarInstancePo.createTlsContext(), namespaceCsv.tenant,
          namespaceCsv.namespace, namespaceCsv.retentionTime, namespaceCsv.retentionSize);
    } on Exception catch (e) {
      log('create namespace [$namespaces] fail. err: $e');
      opException = e;
      notifyListeners();
    }
  }

  Future<List<List<dynamic>>> getAllTopic(Future<List<List<dynamic>>> namespacesFuture) async {
    List<List<dynamic>> topicData = [];
    var namespaces = await namespacesFuture;
    for (var namespace in namespaces) {
      String tenant = namespace[0];
      String name = namespace[1];
      final topics =
          await PulsarPartitionedTopicApi.getTopics(id, host, port, pulsarInstancePo.createTlsContext(), tenant, name);
      for (var topicResp in topics) {
        final partitionedNum = await PulsarPartitionedTopicApi.getBase(
            id, host, port, pulsarInstancePo.createTlsContext(), tenant, name, topicResp.topicName);
        topicData.add([tenant, name, topicResp.topicName, partitionedNum.partitionNum]);
      }
    }
    return topicData;
  }

  Future<void> createAllTopic(List<dynamic> topics) async {
    try {
      PulsarPartitionedTopicApi.createPartitionTopic(id, host, port, pulsarInstancePo.createTlsContext(), topics[0],
          topics[1], topics[2], int.parse('${topics[3]}'));
    } on Exception catch (e) {
      log('create topic [$topics] fail. err: $e');
      opException = e;
      notifyListeners();
    }
  }

  Future<void> createMissTopicPartition() async {
    try {
      progress = 0;
      int count = 0;
      List<Triple<String, String, String>> topicList = List.empty(growable: true);
      for (int i = 0; i < fullList.length; i++) {
        String tenant = fullList[i].tenant;
        List<NamespaceResp> namespaceResps =
            await PulsarNamespaceApi.getNamespaces(id, host, port, pulsarInstancePo.createTlsContext(), tenant);
        for (int j = 0; j < namespaceResps.length; j++) {
          String namespace = namespaceResps[j].namespace;
          final topics = await PulsarPartitionedTopicApi.getTopics(
              id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace);
          topicList.addAll(topics.map((e) => Triple(tenant, namespace, e.topicName)).toList());
        }
        progress = 0.2 * (i / fullList.length);
      }
      for (int i = 0; i < topicList.length; i++) {
        Triple<String, String, String> topicTriple = topicList[i];
        PulsarPartitionedTopicApi.createMissPartitionTopic(id, host, port, pulsarInstancePo.createTlsContext(),
            topicTriple.first, topicTriple.second, topicTriple.third);
        progress = 0.2 + (++count / topicList.length) * 0.8;
        notifyListeners();
      }
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
