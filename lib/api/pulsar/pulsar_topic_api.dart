import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';

class PulsarTopicAPi {
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
}
