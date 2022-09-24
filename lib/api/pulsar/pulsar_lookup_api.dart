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

import 'dart:developer';

import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';

class PulsarLookupApi {
  static Future<String> lookupTopic(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace, String topic) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/lookup/v2/topic/persistent/$tenant/$namespace/$topic';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    return response.data!;
  }
}
