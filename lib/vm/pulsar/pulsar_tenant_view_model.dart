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

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_namespace_api.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/util/common_utils.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';

class PulsarTenantViewModel extends BaseLoadListPageViewModel<PulsarNamespaceViewModel> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;

  @override
  List<PulsarNamespaceViewModel> displayList = <PulsarNamespaceViewModel>[];
  @override
  List<PulsarNamespaceViewModel> fullList = <PulsarNamespaceViewModel>[];

  double progress = 0;

  PulsarTenantViewModel(this.pulsarInstancePo, this.tenantResp);

  PulsarTenantViewModel deepCopy() {
    return PulsarTenantViewModel(pulsarInstancePo.deepCopy(), tenantResp.deepCopy());
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

  String get tenant {
    return tenantResp.tenant;
  }

  double getProgress() {
    return progress;
  }

  Future<void> fetchNamespaces() async {
    try {
      final results =
          await PulsarNamespaceApi.getNamespaces(id, host, port, pulsarInstancePo.createTlsContext(), tenant);
      fullList = results.map((e) => PulsarNamespaceViewModel(pulsarInstancePo, tenantResp, e)).toList();
      displayList = fullList;
      progress = 0;
      loadSuccess();
    } on Exception catch (e) {
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
      displayList = fullList.where((element) => element.namespace.contains(str)).toList();
    }
    notifyListeners();
  }

  Future<void> createNamespace(String namespace) async {
    try {
      await PulsarNamespaceApi.createNamespace(id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace);
      await fetchNamespaces();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> deleteNamespace(String namespace) async {
    try {
      await PulsarNamespaceApi.deleteNamespace(id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace);
      await fetchNamespaces();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> createMissTopicPartition() async {
    try {
      progress = 0;
      int count = 0;
      List<Pair<String, String>> topicList = List.empty(growable: true);
      for (int i = 0; i < fullList.length; i++) {
        PulsarNamespaceViewModel temp = fullList[i];
        final topics = await PulsarPartitionedTopicApi.getTopics(
            id, host, port, pulsarInstancePo.createTlsContext(), tenant, temp.namespace);
        topicList.addAll(topics.map((e) => Pair(temp.namespace, e.topicName)).toList());
      }
      for (int i = 0; i < topicList.length; i++) {
        Pair<String, String> temp = topicList[i];
        PulsarPartitionedTopicApi.createMissPartitionTopic(
            id, host, port, pulsarInstancePo.createTlsContext(), tenant, temp.first, temp.second);
        progress = ++count / topicList.length;
        notifyListeners();
      }
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
