import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_cluster.dart';

class PulsarClusterAPi {
  static Future<List<ClusterResp>> cluster(String host, int port) async {
    var url = 'http://$host:${port.toString()}/admin/v2/brokers/version';
    final versionResponse = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(versionResponse.statusCode)) {
      log('ErrorCode is ${versionResponse.statusCode}, body is ${versionResponse.body}');
      throw Exception(
          'ErrorCode is ${versionResponse.statusCode}, body is ${versionResponse.body}');
    }
    String version = versionResponse.body;

    String tenantInfo = "";
    await PulsarTenantAPi.getTenantInfo(host, port, "public")
        .then((value) => tenantInfo = value);
    String cluster =
        ((json.decode(tenantInfo) as Map)["allowedClusters"] as List)[0];
    url = 'http://$host:${port.toString()}/admin/v2/brokers/$cluster';
    final brokersResponse = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(brokersResponse.statusCode)) {
      log('ErrorCode is ${brokersResponse.statusCode}, body is ${brokersResponse.body}');
      throw Exception(
          'ErrorCode is ${brokersResponse.statusCode}, body is ${brokersResponse.body}');
    }
    List brokers = json.decode(brokersResponse.body) as List;

    url = 'http://$host:${port.toString()}/admin/v2/brokers/leaderBroker';
    final leaderBrokerResponse = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(leaderBrokerResponse.statusCode)) {
      log('ErrorCode is ${leaderBrokerResponse.statusCode}, body is ${leaderBrokerResponse.body}');
      throw Exception(
          'ErrorCode is ${leaderBrokerResponse.statusCode}, body is ${leaderBrokerResponse.body}');
    }
    String leader = json.decode(leaderBrokerResponse.body)["serviceUrl"];

    List<ClusterResp> respList = new List.empty(growable: true);
    brokers.forEach((element) {
      respList.add(new ClusterResp(
          element, leader.contains(element).toString(), version));
    });
    return respList;
  }
}
