//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_cluster.dart';

class PulsarClusterApi {
  static Future<List<ClusterResp>> cluster(int id, String host, int port, TlsContext tlsContext) async {
    String version = await getVersion(id, host, port, tlsContext);
    String tenantInfo = await PulsarTenantApi.getTenantInfo(id, host, port, "public", tlsContext);
    String cluster = ((json.decode(tenantInfo) as Map)["allowedClusters"] as List)[0];
    String url = tlsContext.getSchema() + '$host:${port.toString()}/admin/v2/brokers/$cluster';
    final brokersResponse = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(brokersResponse.statusCode!)) {
      log('ErrorCode is ${brokersResponse.statusCode}, body is ${brokersResponse.data}');
      throw Exception('ErrorCode is ${brokersResponse.statusCode}, body is ${brokersResponse.data}');
    }
    List brokers = json.decode(brokersResponse.data!) as List;
    return brokers.map((e) => ClusterResp(e, version)).toList();
  }

  static Future<String> getVersion(int id, String host, int port, TlsContext tlsContext) async {
    String url = tlsContext.getSchema() + '$host:${port.toString()}/admin/v2/brokers/version';
    final versionResponse = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id)
        .get<String>(url, options: Options(responseType: ResponseType.json));
    if (HttpUtil.abnormal(versionResponse.statusCode!)) {
      log('ErrorCode is ${versionResponse.statusCode}, body is ${versionResponse.data}');
      throw Exception('ErrorCode is ${versionResponse.statusCode}, body is ${versionResponse.data}');
    }
    return versionResponse.data!;
  }

  static Future<String> getLeader(int id, String host, int port, TlsContext tlsContext) async {
    String url = tlsContext.getSchema() + '$host:${port.toString()}/admin/v2/brokers/leaderBroker';
    final leaderBrokerResponse = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(leaderBrokerResponse.statusCode!)) {
      log('ErrorCode is ${leaderBrokerResponse.statusCode}, body is ${leaderBrokerResponse.data}');
      throw Exception('ErrorCode is ${leaderBrokerResponse.statusCode}, body is ${leaderBrokerResponse.data}');
    }
    return json.decode(leaderBrokerResponse.data!)["serviceUrl"];
  }
}
