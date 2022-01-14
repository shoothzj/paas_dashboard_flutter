import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_stat_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_consume.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_produce.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_subscription.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic_base.dart';
import 'package:paas_dashboard_flutter/ui/util/string_util.dart';

class PulsarTopicApi {
  static Future<String> createTopic(String host, int port, String tenant, String namespace, String topic) async {
    var url = 'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic';
    var response = await http.put(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<String> deleteTopic(
      String host, int port, String tenant, String namespace, String topic, bool force) async {
    var url = 'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic?force=$force';
    var response = await http.delete(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<List<TopicResp>> getTopics(String host, int port, String tenant, String namespace) async {
    var url = 'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new TopicResp.fromJson(name)).toList();
  }

  static Future<List<SubscriptionResp>> getSubscription(
      String host, int port, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.topicStats(host, port, tenant, namespace, topic).then((value) => {data = value});
    List<SubscriptionResp> respList = new List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("subscriptions")) {
      Map subscriptionsMap = statsMap["subscriptions"] as Map<String, dynamic>;
      subscriptionsMap.forEach((key, value) {
        double rateOut = value["msgRateOut"];
        int backlog = value["msgBacklog"];
        SubscriptionResp subscriptionDetail = new SubscriptionResp(key, backlog, rateOut);
        respList.add(subscriptionDetail);
      });
    }
    return respList;
  }

  static Future<String> clearBacklog(
      String host, int port, String tenant, String namespace, String topic, String subscription) async {
    var url =
        'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/subscription/$subscription/skip_all';
    final response = await http.post(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<String> getSubscriptionBacklog(
      String host, int port, String tenant, String namespace, String topic, String subscription) async {
    String data = PulsarStatApi.topicStats(host, port, tenant, namespace, topic) as String;

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
      String host, int port, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.topicStats(host, port, tenant, namespace, topic).then((value) => {data = value});
    List<ConsumerResp> respList = new List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("subscriptions")) {
      Map subscriptionsMap = statsMap["subscriptions"] as Map;
      subscriptionsMap.forEach((key, value) {
        Map subMap = value as Map;
        if (subMap.containsKey("consumers")) {
          List consumers = subMap["consumers"] as List;
          consumers.forEach((element) {
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
            ConsumerResp consumerResp = new ConsumerResp(consumerName, key, rateOut, throughputOut, availablePermits,
                unackedMessages, lastConsumedTimestamp, clientVersion, address);
            respList.add(consumerResp);
          });
        }
      });
    }
    return respList;
  }

  static Future<List<ProducerResp>> getProducers(
      String host, int port, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.topicStats(host, port, tenant, namespace, topic).then((value) => {data = value});
    List<ProducerResp> respList = new List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("publishers")) {
      List publisherList = statsMap["publishers"] as List<dynamic>;
      publisherList.forEach((element) {
        String producerName = StringUtil.nullStr(element["producerName"]);
        double rateIn = element["msgRateIn"];
        double throughputIn = element["msgThroughputIn"];
        String clientVersion = StringUtil.nullStr(element["clientVersion"]);
        double averageMsgSize = element["averageMsgSize"];
        String address = StringUtil.nullStr(element["address"]);
        ProducerResp producerResp =
            new ProducerResp(producerName, rateIn, throughputIn, clientVersion, averageMsgSize, address);
        respList.add(producerResp);
      });
    }
    return respList;
  }

  static Future<PulsarTopicBaseResp> getBase(
      String host, int port, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.topicStats(host, port, tenant, namespace, topic).then((value) => {data = value});

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
    return new PulsarTopicBaseResp(
        topicName, partitionNum, msgRateIn, msgRateOut, msgInCounter, msgOutCounter, storageSize);
  }
}
