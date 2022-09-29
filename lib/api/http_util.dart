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

import 'dart:collection';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';

class HttpUtil {
  static const String http = "http://";
  static const String https = "https://";
  static const int CONNECT_TIMEOUT = 30000;
  static const int RECEIVE_TIMEOUT = 30000;
  static Map<SERVER, Map<int, Dio>> clients = {};

  static Dio getClient(TlsContext tlsContext, SERVER service, int id) {
    clients.putIfAbsent(service, () => HashMap.identity());
    clients[service]!.putIfAbsent(id, () => createClient(tlsContext));
    return clients[service]![id]!;
  }

  static Dio createClient(TlsContext tlsContext) {
    BaseOptions options = BaseOptions(
      connectTimeout: CONNECT_TIMEOUT,
      receiveTimeout: RECEIVE_TIMEOUT,
    );
    Dio client = Dio(options);
    if (!tlsContext.enableTls) {
      return client;
    }
    SecurityContext context = SecurityContext();
    if (tlsContext.clientKeyPassword.isNotEmpty) {
      context.usePrivateKey(tlsContext.clientKeyFile, password: tlsContext.clientKeyPassword);
    } else {
      context.usePrivateKey(tlsContext.clientKeyFile);
    }
    context.useCertificateChain(tlsContext.clientCertFile);
    context.setTrustedCertificates(tlsContext.caFile);

    (client.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate = (client) {
      HttpClient httpClient = HttpClient(context: context);
      httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
        return true;
      };
      return httpClient;
    };
    return client;
  }

  static remove(SERVER service, int id) {
    if (clients[service] != null && clients[service]!.containsKey(id)) {
      clients[service]!.remove(id);
    }
  }

  static bool abnormal(int code) {
    return code < 200 || code >= 300;
  }

  static bool normal(int code) {
    return code >= 200 && code < 300;
  }
}

enum SERVER {
  PULSAR,
  PULSAR_FUNCTION,
}
