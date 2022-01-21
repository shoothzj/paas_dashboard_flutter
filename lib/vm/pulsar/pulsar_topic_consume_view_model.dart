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

import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_consume.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_view_model.dart';

class PulsarTopicConsumeViewModel extends BaseLoadListViewModel<ConsumerResp> {
  final PulsarInstancePo pulsarInstancePo;
  final TenantResp tenantResp;
  final NamespaceResp namespaceResp;
  final TopicResp topicResp;
  String? message;
  String? messageId;
  List<Message> messageList = [];

  PulsarTopicConsumeViewModel(this.pulsarInstancePo, this.tenantResp, this.namespaceResp, this.topicResp);

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

  Future<void> fetchConsumerMessage(String messageId) async {
    try {
      var messageIdArr = messageId.split(" ");
      String data;
      message = "";
      messageList = [];
      if (messageIdArr.length == 2) {
        data = await PulsarTopicApi.fetchConsumerMessage(
            host, port, tenant, namespace, topic, messageIdArr[0], messageIdArr[1]);
        this.message = data.substring(data.indexOf("@") + 1);
      }
      if (messageIdArr.length == 3) {
        var startEntryId = int.parse(messageIdArr[1]);
        var endEntryId = int.parse(messageIdArr[2]);
        for (int i = startEntryId; i <= endEntryId; i++) {
          data = await PulsarTopicApi.fetchConsumerMessage(
              host, port, tenant, namespace, topic, messageIdArr[0], i.toString());
          Message message = new Message(i.toString(), data.substring(data.indexOf("@") + 1));
          messageList.add(message);
        }
      }
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }

  Future<void> fetchMessageId(String timestamp) async {
    try {
      if (timestamp == "") {
        return null;
      }
      String data;
      data = await PulsarTopicApi.fetchMessageId(host, port, tenant, namespace, topic, timestamp);
      this.messageId = data;
      loadSuccess();
    } on Exception catch (e) {
      loadException = e;
      loading = false;
    }
    notifyListeners();
  }
}

class Message {
  String entryId;
  String message;

  Message(this.entryId, this.message);
}
