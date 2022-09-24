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

import 'dart:convert';
import 'dart:developer';

import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_stat_api.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';
import 'package:paas_dashboard_flutter/module/pulsar/const.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_consume.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_partitioned_topic_base.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_partitioned_topic_detail.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_produce.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_producer.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_subscription.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/util/string_util.dart';

class PulsarPartitionedTopicApi {
  static Future<String> createPartitionTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String topic, int partitionNum) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitions';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).put<String>(url, data: partitionNum.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    return response.data!;
  }

  static Future<String> deletePartitionTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String topic, bool force) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitions?force=$force';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).delete<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    return response.data!;
  }

  static Future<String> modifyPartitionTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String topic, int partitionNum) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitions';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post<String>(url, data: partitionNum.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    return response.data!;
  }

  static Future<String> createMissPartitionTopic(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/createMissedPartitions';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    return response.data!;
  }

  static Future<List<TopicResp>> getTopics(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/partitioned';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    List jsonResponse = json.decode(response.data!) as List;
    return jsonResponse.map((name) => TopicResp.fromJson(name)).toList();
  }

  static Future<List<SubscriptionResp>> getSubscription(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(id, host, port, tlsContext, tenant, namespace, topic)
        .then((value) => {data = value});
    List<SubscriptionResp> respList = List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("subscriptions")) {
      Map subscriptionsMap = statsMap["subscriptions"] as Map<String, dynamic>;
      subscriptionsMap.forEach((key, value) {
        double rateOut = value["msgRateOut"];
        int backlog = value["msgBacklog"];
        SubscriptionResp subscriptionDetail = SubscriptionResp(key, backlog, rateOut);
        respList.add(subscriptionDetail);
      });
    }
    return respList;
  }

  static Future<String> clearBacklog(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String topic, String subscription) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/subscription/$subscription/skip_all';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    return response.data!;
  }

  static Future<String> getSubscriptionBacklog(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String topic, String subscription) async {
    String data = PulsarStatApi.partitionedTopicStats(id, host, port, tlsContext, tenant, namespace, topic) as String;

    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("subscriptions")) {
      Map subscriptionsMap = statsMap["subscriptions"] as Map;

      if (subscriptionsMap.containsKey(subscription)) {
        Map subscriptionMap = statsMap[subscription] as Map;
        return subscriptionMap["msgBacklog"];
      }
    }
    return "";
  }

  static Future<List<ConsumerResp>> getConsumers(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(id, host, port, tlsContext, tenant, namespace, topic)
        .then((value) => {data = value});
    List<ConsumerResp> respList = List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("subscriptions")) {
      Map subscriptionsMap = statsMap["subscriptions"] as Map;
      subscriptionsMap.forEach((key, value) {
        Map subMap = value as Map;
        if (subMap.containsKey("consumers")) {
          List consumers = subMap["consumers"] as List;
          for (var element in consumers) {
            Map consumer = element as Map;
            double rateOut = 0;
            double throughputOut = 0;
            String clientVersion = "";
            String address = "";
            String consumerName = "";
            double availablePermits = 0;
            double unackedMessages = 0;
            double lastConsumedTimestamp = 0;
            if (consumer.containsKey("consumerName")) {
              consumerName = consumer["consumerName"];
            }
            if (consumer.containsKey("address")) {
              address = consumer["address"];
            }
            if (consumer.containsKey("clientVersion")) {
              clientVersion = consumer["clientVersion"];
            }
            if (consumer.containsKey("throughputOut")) {
              throughputOut = consumer["throughputOut"];
            }
            if (consumer.containsKey("rateOut")) {
              rateOut = consumer["rateOut"];
            }
            if (consumer.containsKey("availablePermits")) {
              availablePermits = consumer["availablePermits"];
            }
            if (consumer.containsKey("unackedMessages")) {
              unackedMessages = consumer["unackedMessages"];
            }
            if (consumer.containsKey("lastConsumedTimestamp")) {
              lastConsumedTimestamp = consumer["lastConsumedTimestamp"];
            }
            ConsumerResp consumerResp = ConsumerResp(consumerName, key, rateOut, throughputOut, availablePermits,
                unackedMessages, lastConsumedTimestamp, clientVersion, address);
            respList.add(consumerResp);
          }
        }
      });
    }
    return respList;
  }

  static Future<List<ProducerResp>> getProducers(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(id, host, port, tlsContext, tenant, namespace, topic)
        .then((value) => {data = value});
    List<ProducerResp> respList = List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("publishers")) {
      List publisherList = statsMap["publishers"] as List<dynamic>;
      for (var element in publisherList) {
        String producerName = StringUtil.nullStr(element["producerName"]);
        double rateIn = element["msgRateIn"];
        double throughputIn = element["msgThroughputIn"];
        String clientVersion = StringUtil.nullStr(element["clientVersion"]);
        double averageMsgSize = element["averageMsgSize"];
        String address = StringUtil.nullStr(element["address"]);
        ProducerResp producerResp =
            ProducerResp(producerName, rateIn, throughputIn, clientVersion, averageMsgSize, address);
        respList.add(producerResp);
      }
    }
    return respList;
  }

  static Future<List<PulsarPartitionedTopicDetailResp>> getDetails(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(id, host, port, tlsContext, tenant, namespace, topic)
        .then((value) => {data = value});
    List<PulsarPartitionedTopicDetailResp> respList = List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("partitions")) {
      Map partitionsMap = statsMap["partitions"] as Map<String, dynamic>;
      partitionsMap.forEach((key, value) {
        int backlog = value["backlogSize"];
        var resp = PulsarPartitionedTopicDetailResp(key, backlog);
        respList.add(resp);
      });
    }
    return respList;
  }

  static Future<PulsarPartitionedTopicBaseResp> getBase(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(id, host, port, tlsContext, tenant, namespace, topic)
        .then((value) => {data = value});

    Map statsMap = json.decode(data) as Map;
    String topicName = topic;
    int partitionNum = 0;
    double msgRateIn = 0;
    double msgRateOut = 0;
    int msgInCounter = 0;
    int msgOutCounter = 0;
    int storageSize = 0;

    if (statsMap.containsKey("metadata")) {
      Map metadata = statsMap["metadata"] as Map;
      partitionNum = metadata["partitions"];
    }
    if (statsMap.containsKey("msgRateIn")) {
      msgRateIn = statsMap["msgRateIn"];
    }
    if (statsMap.containsKey("msgRateOut")) {
      msgRateOut = statsMap["msgRateOut"];
    }
    if (statsMap.containsKey("msgInCounter")) {
      msgInCounter = statsMap["msgInCounter"];
    }
    if (statsMap.containsKey("msgOutCounter")) {
      msgOutCounter = statsMap["msgOutCounter"];
    }
    if (statsMap.containsKey("storageSize")) {
      storageSize = statsMap["storageSize"];
    }
    return PulsarPartitionedTopicBaseResp(
        topicName, partitionNum, msgRateIn, msgRateOut, msgInCounter, msgOutCounter, storageSize);
  }

  static Future<String> sendMsgToPartitionTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String topic, String key, String value) async {
    ProducerMessage producerMessage = ProducerMessage(key, value);
    List<ProducerMessage> messageList = List.empty(growable: true);
    messageList.add(producerMessage);
    PublishMessagesReq messagesReq = PublishMessagesReq(PulsarConst.defaultProducerName, messageList);
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/topics/persistent/$tenant/$namespace/$topic/';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post<String>(url, data: json.encode(messagesReq));
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      return "send msg failed, ${response.data!}";
    }
    return "send msg success";
  }
}
