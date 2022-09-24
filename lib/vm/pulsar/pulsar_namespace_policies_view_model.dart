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

class PulsarNamespacePoliciesViewModel extends BaseLoadViewModel {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  bool? isAllowAutoTopicCreation;
  String? topicType;
  int? defaultNumPartitions;
  List<String>? boundaries;
  int? numBundles;
  int? messageTTLInSeconds;
  int? maxProducersPerTopic;
  int? maxConsumersPerTopic;
  int? maxConsumersPerSubscription;
  int? maxUnackedMessagesPerConsumer;
  int? maxUnackedMessagesPerSubscription;
  int? maxSubscriptionsPerTopic;
  int? maxTopicsPerNamespace;

  PulsarNamespacePoliciesViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp);

  PulsarNamespacePoliciesViewModel deepCopy() {
    return PulsarNamespacePoliciesViewModel(
        pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy());
  }

  Future<void> fetchPolicy() async {
    try {
      final PolicyResp resp =
          await PulsarNamespaceApi.getPolicy(id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace);
      isAllowAutoTopicCreation = resp.isAllowAutoTopicCreation;
      messageTTLInSeconds = resp.messageTTLInSeconds;
      maxProducersPerTopic = resp.maxProducersPerTopic;
      maxConsumersPerTopic = resp.maxConsumersPerTopic;
      maxConsumersPerSubscription = resp.maxConsumersPerSubscription;
      maxUnackedMessagesPerConsumer = resp.maxUnackedMessagesPerConsumer;
      maxUnackedMessagesPerSubscription = resp.maxUnackedMessagesPerSubscription;
      maxSubscriptionsPerTopic = resp.maxSubscriptionsPerTopic;
      maxTopicsPerNamespace = resp.maxTopicsPerNamespace;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
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

  String get namespace {
    return namespaceResp.namespace;
  }

  String get isAllowAutoTopicCreateDisplayStr {
    if (isAllowAutoTopicCreation == null) {
      return UiConst.unset;
    }
    return isAllowAutoTopicCreation.toString();
  }

  String get messageTTLDisplayStr {
    if (messageTTLInSeconds == null) {
      return UiConst.unset;
    }
    return messageTTLInSeconds.toString();
  }

  String get maxProducersPerTopicDisplayStr {
    if (maxProducersPerTopic == null) {
      return UiConst.unset;
    }
    return maxProducersPerTopic.toString();
  }

  String get maxConsumersPerTopicDisplayStr {
    if (maxConsumersPerTopic == null) {
      return UiConst.unset;
    }
    return maxConsumersPerTopic.toString();
  }

  String get maxConsumersPerSubscriptionDisplayStr {
    if (maxConsumersPerSubscription == null) {
      return UiConst.unset;
    }
    return maxConsumersPerSubscription.toString();
  }

  String get maxUnackedMessagesPerConsumerDisplayStr {
    if (maxUnackedMessagesPerConsumer == null) {
      return UiConst.unset;
    }
    return maxUnackedMessagesPerConsumer.toString();
  }

  String get maxUnackedMessagesPerSubscriptionDisplayStr {
    if (maxUnackedMessagesPerSubscription == null) {
      return UiConst.unset;
    }
    return maxUnackedMessagesPerSubscription.toString();
  }

  String get maxSubscriptionsPerTopicDisplayStr {
    if (maxSubscriptionsPerTopic == null) {
      return UiConst.unset;
    }
    return maxSubscriptionsPerTopic.toString();
  }

  String get maxTopicsPerNamespaceDisplayStr {
    if (maxTopicsPerNamespace == null) {
      return UiConst.unset;
    }
    return maxTopicsPerNamespace.toString();
  }

  Future<void> updateAutoTopicCreate() async {
    try {
      if (isAllowAutoTopicCreation == null) {
        return;
      }
      if (topicType == null) {
        return;
      }
      if (defaultNumPartitions == null) {
        return;
      }
      await PulsarNamespaceApi.setAutoTopicCreation(id, host, port, pulsarInstancePo.createTlsContext(), tenant,
          namespace, isAllowAutoTopicCreation, topicType, defaultNumPartitions);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMessageTTLSecond() async {
    try {
      if (messageTTLInSeconds == null) {
        return;
      }
      await PulsarNamespaceApi.setMessageTTLSecond(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, messageTTLInSeconds);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxProducersPerTopic() async {
    try {
      if (maxProducersPerTopic == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxProducersPerTopic(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxProducersPerTopic);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxConsumersPerTopic() async {
    try {
      if (maxConsumersPerTopic == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxConsumersPerTopic(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxConsumersPerTopic);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxConsumersPerSubscription() async {
    try {
      if (maxConsumersPerSubscription == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxConsumersPerSubscription(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxConsumersPerSubscription);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxUnackedMessagesPerConsumer() async {
    try {
      if (maxUnackedMessagesPerConsumer == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxUnackedMessagesPerConsumer(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxUnackedMessagesPerConsumer);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxUnackedMessagesPerSubscription() async {
    try {
      if (maxUnackedMessagesPerSubscription == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxUnackedMessagesPerSubscription(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxUnackedMessagesPerSubscription);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxSubscriptionsPerTopic() async {
    try {
      if (maxSubscriptionsPerTopic == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxSubscriptionsPerTopic(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxSubscriptionsPerTopic);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }

  Future<void> setMaxTopicsPerNamespace() async {
    try {
      if (maxTopicsPerNamespace == null) {
        return;
      }
      await PulsarNamespaceApi.setMaxTopicsPerNamespace(
          id, host, port, pulsarInstancePo.createTlsContext(), tenant, namespace, maxTopicsPerNamespace);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
