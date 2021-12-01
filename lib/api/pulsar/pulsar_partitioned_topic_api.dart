import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_stat_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_partitioned_topic_detail.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_produce.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_subscription.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/util/string_util.dart';

class PulsarPartitionedTopicApi {
  static Future<String> createPartitionTopic(String host, int port,
      String tenant, String namespace, String topic, int partitionNum) async {
    var url =
        'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitions';
    var response = await http.put(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: partitionNum.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<String> deletePartitionTopic(String host, int port,
      String tenant, String namespace, String topic) async {
    var url =
        'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitions';
    var response = await http.delete(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<String> modifyPartitionTopic(String host, int port,
      String tenant, String namespace, String topic, int partitionNum) async {
    var url =
        'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitions';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: partitionNum.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<List<TopicResp>> getTopics(
      String host, int port, String tenant, String namespace) async {
    var url =
        'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/partitioned';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new TopicResp.fromJson(name)).toList();
  }

  static Future<List<SubscriptionResp>> getSubscription(String host, int port,
      String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(
            host, port, tenant, namespace, topic)
        .then((value) => {data = value});
    List<SubscriptionResp> respList = new List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("subscriptions")) {
      Map subscriptionsMap = statsMap["subscriptions"] as Map<String, dynamic>;
      subscriptionsMap.forEach((key, value) {
        double rateOut = value["msgRateOut"];
        int backlog = value["msgBacklog"];
        SubscriptionResp subscriptionDetail =
            new SubscriptionResp(key, backlog, rateOut);
        respList.add(subscriptionDetail);
      });
    }
    return respList;
  }

  static Future<String> clearBacklog(String host, int port, String tenant,
      String namespace, String topic, String subscription) async {
    var url =
        'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/subscription/$subscription/skip_all';
    final response = await http.post(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<String> getSubscriptionBacklog(
      String host,
      int port,
      String tenant,
      String namespace,
      String topic,
      String subscription) async {
    String data = PulsarStatApi.partitionedTopicStats(
        host, port, tenant, namespace, topic) as String;

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

  static Future<List<ProducerResp>> getProducers(String host, int port,
      String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(
            host, port, tenant, namespace, topic)
        .then((value) => {data = value});
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
        ProducerResp producerResp = new ProducerResp(producerName, rateIn,
            throughputIn, clientVersion, averageMsgSize, address);
        respList.add(producerResp);
      });
    }
    return respList;
  }

  static Future<List<PulsarPartitionedTopicDetailResp>> getDetails(String host,
      int port, String tenant, String namespace, String topic) async {
    String data = "";
    await PulsarStatApi.partitionedTopicStats(
            host, port, tenant, namespace, topic)
        .then((value) => {data = value});
    List<PulsarPartitionedTopicDetailResp> respList =
        new List.empty(growable: true);
    Map statsMap = json.decode(data) as Map;
    if (statsMap.containsKey("partitions")) {
      Map partitionsMap = statsMap["partitions"] as Map<String, dynamic>;
      partitionsMap.forEach((key, value) {
        int backlog = value["backlogSize"];
        var resp = new PulsarPartitionedTopicDetailResp(key, backlog);
        respList.add(resp);
      });
    }
    return respList;
  }
}
