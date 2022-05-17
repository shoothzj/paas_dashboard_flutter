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
import 'package:paas_dashboard_flutter/const/ui_const.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class PulsarNamespaceBacklogQuotaViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  int? limitSize;
  int? limitTime;
  String? retentionPolicy;

  PulsarNamespaceBacklogQuotaViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp);

  PulsarNamespaceBacklogQuotaViewModel deepCopy() {
    return new PulsarNamespaceBacklogQuotaViewModel(
        pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy());
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

  set limitSizeDisplayStr(String displayStr) {
    if (displayStr == UiConst.unset) {
      return;
    }
    this.limitSize = int.parse(displayStr);
  }

  String get limitSizeDisplayStr {
    if (loading) {
      return UiConst.loading;
    }
    if (limitSize == null) {
      return UiConst.unset;
    }
    return limitSize!.toString();
  }

  set limitTimeDisplayStr(String displayStr) {
    if (displayStr == UiConst.unset) {
      return;
    }
    this.limitTime = int.parse(displayStr);
  }

  String get limitTimeDisplayStr {
    if (loading) {
      return UiConst.loading;
    }
    if (limitTime == null) {
      return UiConst.unset;
    }
    return limitTime!.toString();
  }

  set retentionPolicyDisplayStr(String displayStr) {
    if (displayStr == UiConst.unset) {
      return;
    }
    this.retentionPolicy = displayStr;
  }

  String get retentionPolicyDisplayStr {
    if (loading) {
      return UiConst.loading;
    }
    if (retentionPolicy == null) {
      return UiConst.unset;
    }
    return retentionPolicy!;
  }

  Future<void> fetchBacklogQuota() async {
    try {
      final BacklogQuotaResp resp = await PulsarNamespaceApi.getBacklogQuota(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace);
      this.limitSize = resp.limitSize;
      this.limitTime = resp.limitTime;
      this.retentionPolicy = resp.policy;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> updateBacklogQuota() async {
    try {
      if (limitSize == null) {
        return;
      }
      if (retentionPolicy == null) {
        return;
      }
      await PulsarNamespaceApi.updateBacklogQuota(id, host, port, pulsarInstancePo.createTlsContext(), tenant,
          namespace, limitSize!, limitTime, retentionPolicy!);
      await fetchBacklogQuota();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
