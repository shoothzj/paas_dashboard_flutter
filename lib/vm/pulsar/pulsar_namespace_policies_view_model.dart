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
    return new PulsarNamespacePoliciesViewModel(
        pulsarInstancePo.deepCopy(), tenantResp.deepCopy(), namespaceResp.deepCopy());
  }

  Future<void> fetchPolicy() async {
    try {
      final PolicyResp resp = await PulsarNamespaceApi.getPolicy(host, port, tenant, namespace);
      this.isAllowAutoTopicCreation = resp.isAllowAutoTopicCreation;
      this.messageTTLInSeconds = resp.messageTTLInSeconds;
      this.maxProducersPerTopic = resp.maxProducersPerTopic;
      this.maxConsumersPerTopic = resp.maxConsumersPerTopic;
      this.maxConsumersPerSubscription = resp.maxConsumersPerSubscription;
      this.maxUnackedMessagesPerConsumer = resp.maxUnackedMessagesPerConsumer;
      this.maxUnackedMessagesPerSubscription = resp.maxUnackedMessagesPerSubscription;
      this.maxSubscriptionsPerTopic = resp.maxSubscriptionsPerTopic;
      this.maxTopicsPerNamespace = resp.maxTopicsPerNamespace;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
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

  String get isAllowAutoTopicCreateDisplayStr {
    if (this.isAllowAutoTopicCreation == null) {
      return "unset";
    }
    return this.isAllowAutoTopicCreation.toString();
  }

  String get messageTTLDisplayStr {
    if (this.messageTTLInSeconds == null) {
      return "unset";
    }
    return this.messageTTLInSeconds.toString();
  }

  String get maxProducersPerTopicDisplayStr {
    if (this.maxProducersPerTopic == null) {
      return "unset";
    }
    return this.maxProducersPerTopic.toString();
  }

  String get maxConsumersPerTopicDisplayStr {
    if (this.maxConsumersPerTopic == null) {
      return "unset";
    }
    return this.maxConsumersPerTopic.toString();
  }

  String get maxConsumersPerSubscriptionDisplayStr {
    if (this.maxConsumersPerSubscription == null) {
      return "unset";
    }
    return this.maxConsumersPerSubscription.toString();
  }

  String get maxUnackedMessagesPerConsumerDisplayStr {
    if (this.maxUnackedMessagesPerConsumer == null) {
      return "unset";
    }
    return this.maxUnackedMessagesPerConsumer.toString();
  }

  String get maxUnackedMessagesPerSubscriptionDisplayStr {
    if (this.maxUnackedMessagesPerSubscription == null) {
      return "unset";
    }
    return this.maxUnackedMessagesPerSubscription.toString();
  }

  String get maxSubscriptionsPerTopicDisplayStr {
    if (this.maxSubscriptionsPerTopic == null) {
      return "unset";
    }
    return this.maxSubscriptionsPerTopic.toString();
  }

  String get maxTopicsPerNamespaceDisplayStr {
    if (this.maxTopicsPerNamespace == null) {
      return "unset";
    }
    return this.maxTopicsPerNamespace.toString();
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
      await PulsarNamespaceApi.setAutoTopicCreation(
          host, port, tenant, namespace, isAllowAutoTopicCreation, topicType, defaultNumPartitions);
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
      await PulsarNamespaceApi.setMessageTTLSecond(host, port, tenant, namespace, messageTTLInSeconds);
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
      await PulsarNamespaceApi.setMaxProducersPerTopic(host, port, tenant, namespace, maxProducersPerTopic);
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
      await PulsarNamespaceApi.setMaxConsumersPerTopic(host, port, tenant, namespace, maxConsumersPerTopic);
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
          host, port, tenant, namespace, maxConsumersPerSubscription);
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
          host, port, tenant, namespace, maxUnackedMessagesPerConsumer);
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
          host, port, tenant, namespace, maxUnackedMessagesPerSubscription);
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
      await PulsarNamespaceApi.setMaxSubscriptionsPerTopic(host, port, tenant, namespace, maxSubscriptionsPerTopic);
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
      await PulsarNamespaceApi.setMaxTopicsPerNamespace(host, port, tenant, namespace, maxTopicsPerNamespace);
      await fetchPolicy();
    } on Exception catch (e) {
      opException = e;
      notifyListeners();
    }
  }
}
