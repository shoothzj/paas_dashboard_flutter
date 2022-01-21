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

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_sink_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_view_model.dart';

class PulsarSinkListViewModel extends BaseLoadListPageViewModel<PulsarSinkViewModel> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;

  PulsarSinkListViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp);

  PulsarSinkListViewModel deepCopy() {
    return new PulsarSinkListViewModel(pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy());
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

  String get functionHost {
    return this.pulsarInstancePo.functionHost;
  }

  int get functionPort {
    return this.pulsarInstancePo.functionPort;
  }

  String get tenant {
    return this.tenantResp.tenant;
  }

  String get namespace {
    return this.namespaceResp.namespace;
  }

  Future<void> createSink(String sinkName, String subName, String inputTopic, String sinkType, String config) async {
    try {
      await PulsarSinkApi.createSink(
          functionHost, functionPort, tenant, namespace, sinkName, subName, inputTopic, sinkType, config);
      await fetchSinks();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> fetchSinks() async {
    try {
      final results = await PulsarSinkApi.getSinkList(functionHost, functionPort, tenant, namespace);
      this.fullList = results.map((e) => PulsarSinkViewModel(pulsarInstancePo, tenantResp, namespaceResp, e)).toList();
      this.displayList = this.fullList;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> filter(String str) async {
    if (str == "") {
      this.displayList = this.fullList;
      notifyListeners();
      return;
    }
    if (!loading && loadException == null) {
      this.displayList = this.fullList.where((element) => element.sinkName.contains(str)).toList();
    }
    notifyListeners();
  }

  Future<void> deleteSink(String name) async {
    try {
      await PulsarSinkApi.deleteSink(functionHost, functionPort, tenant, namespace, name);
      await fetchSinks();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
