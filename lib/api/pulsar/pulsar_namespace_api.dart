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
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/api/tls_context.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';

class PulsarNamespaceApi {
  static Future<void> createNamespace(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).put<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> deleteNamespace(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    var url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).delete<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<List<NamespaceResp>> getNamespaces(
      int id, String host, int port, TlsContext tlsContext, String tenant) async {
    var url =
        tlsContext.enableTls ? HttpUtil.https : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    List jsonResponse = json.decode(response.data!) as List;
    return jsonResponse.map((name) => NamespaceResp.fromJson(name)).toList();
  }

  static Future<RetentionResp> getRetention(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/retention';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    if ("" == response.data!) {
      return RetentionResp(null, null);
    }
    Map jsonResponse = json.decode(response.data!) as Map;
    return RetentionResp.fromJson(jsonResponse);
  }

  static Future<void> setRetention(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int retentionTimeInMinutes, int retentionSizeInMB) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/retention';
    RetentionResp retentionResp = RetentionResp(retentionTimeInMinutes, retentionSizeInMB);
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: json.encode(retentionResp));
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<BacklogQuotaResp> getBacklogQuota(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/backlogQuotaMap';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    Map jsonResponse = json.decode(response.data!) as Map;
    var destinationStorageResp = jsonResponse["destination_storage"];
    if (destinationStorageResp == null) {
      return BacklogQuotaResp(null, null, null);
    }
    return BacklogQuotaResp.fromJson(destinationStorageResp);
  }

  static Future<void> updateBacklogQuota(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int limit, int? limitTime, String policy) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/backlogQuota';
    BacklogQuotaReq backlogQuotaReq = BacklogQuotaReq(limit, limitTime, policy);
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: json.encode(backlogQuotaReq));
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<PolicyResp> getPolicy(
      int id, String host, int port, TlsContext tlsContext, String tenant, String namespace) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).get<String>(url);
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
    Map jsonResponse = json.decode(response.data!) as Map;
    return PolicyResp.fromJson(jsonResponse);
  }

  static Future<void> setAutoTopicCreation(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, bool? allowAutoTopicCreation, String? topicType, int? defaultNumPartitions) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/autoTopicCreation';
    TopicAutoCreateReq topicAutoCreateReq = TopicAutoCreateReq(allowAutoTopicCreation, topicType, defaultNumPartitions);
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: json.encode(topicAutoCreateReq));
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMessageTTLSecond(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int? messageTTLSecond) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/messageTTL';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: messageTTLSecond.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxProducersPerTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int? maxProducersPerTopic) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxProducersPerTopic';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: maxProducersPerTopic.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxConsumersPerTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int? maxConsumersPerTopic) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxConsumersPerTopic';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: maxConsumersPerTopic.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxConsumersPerSubscription(int id, String host, int port, TlsContext tlsContext,
      String tenant, String namespace, int? maxConsumersPerSubscription) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxConsumersPerSubscription';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: maxConsumersPerSubscription.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxUnackedMessagesPerConsumer(int id, String host, int port, TlsContext tlsContext,
      String tenant, String namespace, int? maxUnackedMessagesPerConsumer) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxUnackedMessagesPerConsumer';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id)
        .post(url, data: maxUnackedMessagesPerConsumer.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxUnackedMessagesPerSubscription(int id, String host, int port, TlsContext tlsContext,
      String tenant, String namespace, int? maxUnackedMessagesPerSubscription) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxUnackedMessagesPerSubscription';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id)
        .post(url, data: maxUnackedMessagesPerSubscription.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxSubscriptionsPerTopic(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int? maxSubscriptionsPerTopic) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxSubscriptionsPerTopic';
    var response =
        await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id).post(url, data: maxSubscriptionsPerTopic.toString());
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }

  static Future<void> setMaxTopicsPerNamespace(int id, String host, int port, TlsContext tlsContext, String tenant,
      String namespace, int? maxTopicsPerNamespace) async {
    String url = tlsContext.enableTls
        ? HttpUtil.https
        : '${HttpUtil.http}$host:${port.toString()}/admin/v2/namespaces/$tenant/$namespace/maxTopicsPerNamespace';
    var response = await HttpUtil.getClient(tlsContext, SERVER.PULSAR, id)
        .post(url, data: maxTopicsPerNamespace.toString(), options: Options(contentType: ContentType.json.toString()));
    if (HttpUtil.abnormal(response.statusCode!)) {
      log('ErrorCode is ${response.statusCode}, body is ${response.data}');
      throw Exception('ErrorCode is ${response.statusCode}, body is ${response.data}');
    }
  }
}
