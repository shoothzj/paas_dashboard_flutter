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

import 'package:clipboard/clipboard.dart';
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_source.dart';

class PulsarSourceApi {
  static Future<void> createSource(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, String sourceName, String outputTopic, String sourceType, String config) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sourceName';
    SourceConfigReq sinkConfigReq =
        SourceConfigReq(sourceName, tenant, namespace, outputTopic, json.decode(config), "builtin://$sourceType");
    String curlCommand = "curl '$url' -F sourceConfig='${jsonEncode(sinkConfigReq)};type=application/json'";
    await FlutterClipboard.copy(curlCommand);
  }

  static Future<void> deleteSource(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String sourceName) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v3/sources/$tenant/$namespace/$sourceName';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR_FUNCTION, id).delete<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<List<SourceResp>> getSourceList(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v3/sources/$tenant/$namespace';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR_FUNCTION, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    List jsonResponse = json.decode(response.data!) as List;
    return jsonResponse.map((name) => SourceResp(name)).toList();
  }

  static Future<SourceConfigResp> getSource(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String sourceName) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v3/sources/$tenant/$namespace/$sourceName';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR_FUNCTION, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    Map jsonResponse = json.decode(response.data!) as Map;
    return SourceConfigResp.fromJson(jsonResponse);
  }
}
