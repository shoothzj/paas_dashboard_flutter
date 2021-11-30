import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_sink.dart';

class PulsarSinkAPi {
  static Future<void> deleteSink(String host, int port, String tenant,
      String namespace, String sinkName) async {
    var url =
        'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sinkName';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<SinkResp>> getSinkList(
      String host, int port, String tenant, String namespace) async {
    var url =
        'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new SinkResp(name)).toList();
  }
}
