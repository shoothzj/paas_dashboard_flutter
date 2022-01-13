import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';

class PulsarNamespaceApi {
  static Future<void> createNamespace(String host, int port, String tenant, String namespace) async {
    var url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    final response = await http.put(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> deleteNamespace(String host, int port, String tenant, String namespace) async {
    var url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<NamespaceResp>> getNamespaces(String host, int port, String tenant) async {
    var url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new NamespaceResp.fromJson(name)).toList();
  }

  static Future<BacklogQuotaResp> getBacklogQuota(String host, int port, String tenant, String namespace) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/backlogQuotaMap';
    var response = await http.get(Uri.parse(url), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    });
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    Map jsonResponse = json.decode(response.body) as Map;
    var destinationStorageResp = jsonResponse["destination_storage"];
    if (destinationStorageResp == null) {
      return new BacklogQuotaResp(null, null, null);
    }
    return BacklogQuotaResp.fromJson(destinationStorageResp);
  }

  static Future<void> updateBacklogQuota(
      String host, int port, String tenant, String namespace, int limit, int? limitTime, String policy) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/backlogQuota';
    BacklogQuotaReq backlogQuotaReq = new BacklogQuotaReq(limit, limitTime, policy);
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(backlogQuotaReq));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<PolicyResp> getPolicy(String host, int port, String tenant, String namespace) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    var response =
        await http.get(Uri.parse(url), headers: <String, String>{'Content-Type': 'application/json; charset=utf-8'});
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    Map jsonResponse = json.decode(response.body) as Map;
    return PolicyResp.fromJson(jsonResponse);
  }

  static Future<void> setAutoTopicCreation(String host, int port, String tenant, String namespace,
      bool? allowAutoTopicCreation, String? topicType, int? defaultNumPartitions) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/autoTopicCreation';
    TopicAutoCreateReq topicAutoCreateReq =
        new TopicAutoCreateReq(allowAutoTopicCreation, topicType, defaultNumPartitions);
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(topicAutoCreateReq));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMessageTTLSecond(
      String host, int port, String tenant, String namespace, int? messageTTLSecond) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/messageTTL';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: messageTTLSecond.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxProducersPerTopic(
      String host, int port, String tenant, String namespace, int? maxProducersPerTopic) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxProducersPerTopic';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxProducersPerTopic.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxConsumersPerTopic(
      String host, int port, String tenant, String namespace, int? maxConsumersPerTopic) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxConsumersPerTopic';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxConsumersPerTopic.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxConsumersPerSubscription(
      String host, int port, String tenant, String namespace, int? maxConsumersPerSubscription) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxConsumersPerSubscription';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxConsumersPerSubscription.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxUnackedMessagesPerConsumer(
      String host, int port, String tenant, String namespace, int? maxUnackedMessagesPerConsumer) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxUnackedMessagesPerConsumer';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxUnackedMessagesPerConsumer.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxUnackedMessagesPerSubscription(
      String host, int port, String tenant, String namespace, int? maxUnackedMessagesPerSubscription) async {
    String url =
        'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxUnackedMessagesPerSubscription';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxUnackedMessagesPerSubscription.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxSubscriptionsPerTopic(
      String host, int port, String tenant, String namespace, int? maxSubscriptionsPerTopic) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxSubscriptionsPerTopic';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxSubscriptionsPerTopic.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> setMaxTopicsPerNamespace(
      String host, int port, String tenant, String namespace, int? maxTopicsPerNamespace) async {
    String url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxTopicsPerNamespace';
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: maxTopicsPerNamespace.toString());
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }
}
