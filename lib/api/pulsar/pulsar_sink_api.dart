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
import 'package:http/http.dart' as http;
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_sink.dart';

class PulsarSinkApi {
  static Future<void> createSink(String host, int port, String tenant, String namespace, String sinkName,
      String subName, String inputTopic, String sinkType, String config) async {
    String url = 'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sinkName';
    List<String> inputs = [inputTopic];
    SinkConfigReq sinkConfigReq =
        new SinkConfigReq(tenant, namespace, sinkName, subName, inputs, json.decode(config), "builtin://$sinkType");
    String curlCommand = "curl '$url' -F sinkConfig='" + jsonEncode(sinkConfigReq) + ";type=application/json'";
    await FlutterClipboard.copy(curlCommand);
  }

  static Future<void> deleteSink(String host, int port, String tenant, String namespace, String sinkName) async {
    var url = 'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sinkName';
    final response = await http.delete(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
  }

  static Future<List<SinkResp>> getSinkList(String host, int port, String tenant, String namespace) async {
    var url = 'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    List jsonResponse = json.decode(response.body) as List;
    return jsonResponse.map((name) => new SinkResp(name)).toList();
  }

  static Future<SinkConfigResp> getSink(String host, int port, String tenant, String namespace, String sinkName) async {
    var url = 'http://$host:${port.toString()}/admin/v3/sinks/$tenant/$namespace/$sinkName';
    final response = await http.get(Uri.parse(url));
    if (HttpUtil.abnormal(response.statusCode)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.body}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.body}');
    }
    Map jsonResponse = json.decode(response.body) as Map;
    return SinkConfigResp.fromJson(jsonResponse);
  }
}
