import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';

class PulsarTenantAPi {
  static Future<void> createTenant(String host, int port, String tenantName) async {
    var url = 'http://$host:${port.toString()}/admin/v2/tenants/$tenantName';
    final response = await http.put(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<void> deleteTenant(String host, int port, String tenantName) async {
    var url = 'http://$host:${port.toString()}/admin/v2/tenants/$tenantName';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<TenantResp>> getTenants(String host, int port) async {
    var url = 'http://$host:${port.toString()}/admin/v2/tenants';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new TenantResp.fromJson(name)).toList();
  }
}
