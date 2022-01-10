import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_cluster.dart';

class PulsarClusterApi {
  static Future<List<ClusterResp>> cluster(String host, int port) async {
    String version = await getVersion(host, port);
    String tenantInfo = await PulsarTenantApi.getTenantInfo(host, port, "public");
    String cluster = ((json.decode(tenantInfo) as Map)["allowedClusters"] as List)[0];
    String url = 'http://$host:${port.toString()}/admin/v2/brokers/$cluster';
    final brokersResponse = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(brokersResponse.statusCode)) {
      log('ErrorCode is ${brokersResponse.statusCode}, body is ${brokersResponse.body}');
      throw Exception('ErrorCode is ${brokersResponse.statusCode}, body is ${brokersResponse.body}');
    }
    List brokers = json.decode(brokersResponse.body) as List;
    return brokers.map((e) => ClusterResp(e, version)).toList();
  }

  static Future<String> getVersion(String host, int port) async {
    String url = 'http://$host:${port.toString()}/admin/v2/brokers/version';
    final versionResponse = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(versionResponse.statusCode)) {
      log('ErrorCode is ${versionResponse.statusCode}, body is ${versionResponse.body}');
      throw Exception('ErrorCode is ${versionResponse.statusCode}, body is ${versionResponse.body}');
    }
    return versionResponse.body;
  }

  static Future<String> getLeader(String host, int port) async {
    String url = 'http://$host:${port.toString()}/admin/v2/brokers/leaderBroker';
    final leaderBrokerResponse = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(leaderBrokerResponse.statusCode)) {
      log('ErrorCode is ${leaderBrokerResponse.statusCode}, body is ${leaderBrokerResponse.body}');
      throw Exception('ErrorCode is ${leaderBrokerResponse.statusCode}, body is ${leaderBrokerResponse.body}');
    }
    return json.decode(leaderBrokerResponse.body)["serviceUrl"];
  }
}
