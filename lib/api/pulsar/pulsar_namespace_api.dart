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

  static Future<void> deleteNamespace(
      String host, int port, String tenant, String namespace) async {
    var url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<NamespaceResp>> getNamespaces(
      String host, int port, String tenant) async {
    var url = 'http://$host:${port.toString()}/admin/v2/namespaces/$tenant';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse
        .map((name) => new NamespaceResp.fromJson(name))
        .toList();
  }

  static Future<BacklogQuotaResp> getBacklogQuota(String host, int port, String tenant,
      String namespace) async {
    String url =
        'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/backlogQuotaMap';
    var response = await http.get(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    Map jsonResponse = json.decode(response.body) as Map;
    return BacklogQuotaResp.fromJson(jsonResponse["destination_storage"]);
  }

  static Future<void> updateBacklogQuota(String host, int port, String tenant,
      String namespace, int limit, int? limitTime, String policy) async {
    String url =
        'http://$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/backlogQuota';
    BacklogQuotaReq backlogQuotaReq = new BacklogQuotaReq(limit, limitTime, policy);
    var response = await http.post(Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(backlogQuotaReq));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception(
          'ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

}
