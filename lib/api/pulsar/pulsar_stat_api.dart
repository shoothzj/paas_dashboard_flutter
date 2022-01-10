import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';

class PulsarStatApi {
  static Future<String> partitionedTopicStats(
      String host, int port, String tenant, String namespace, String topic) async {
    var url = 'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/partitioned-stats';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }

  static Future<String> topicStats(String host, int port, String tenant, String namespace, String topic) async {
    var url = 'http://$host:${port.toString()}/admin/v2/persistent/$tenant/$namespace/$topic/stats';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    return response.body;
  }
}
