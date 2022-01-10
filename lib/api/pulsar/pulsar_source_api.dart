import 'dart:convert';
import 'dart:developer';

import 'package:clipboard/clipboard.dart';
import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_source.dart';

class PulsarSourceApi {
  static Future<void> createSource(
      String host,
      int port,
      String tenant,
      String namespace,
      String sourceName,
      String outputTopic,
      String sourceType,
      String config) async {
    String url =
        'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sourceName';
    SourceConfigReq sinkConfigReq = new SourceConfigReq(sourceName, tenant,
        namespace, outputTopic, json.decode(config), "builtin://$sourceType");
    String curlCommand = "curl '$url' -F sourceConfig='" +
        jsonEncode(sinkConfigReq) +
        ";type=application/json'";
    await FlutterClipboard.copy(curlCommand);
  }

  static Future<void> deleteSource(String host, int port, String tenant,
      String namespace, String sourceName) async {
    var url =
        'http://$host:${port.toString()}/admin/v3/sources/$tenant/$namespace/$sourceName';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<SourceResp>> getSourceList(
      String host, int port, String tenant, String namespace) async {
    var url =
        'http://$host:${port.toString()}/admin/v3/sources/$tenant/$namespace';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new SourceResp(name)).toList();
  }

  static Future<SourceConfigResp> getSource(String host, int port,
      String tenant, String namespace, String sourceName) async {
    var url =
        'http://$host:${port.toString()}/admin/v3/sources/$tenant/$namespace/$sourceName';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    Map jsonResponse = json.decode(response.body) as Map;
    return SourceConfigResp.fromJson(jsonResponse);
  }
}
