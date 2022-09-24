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
