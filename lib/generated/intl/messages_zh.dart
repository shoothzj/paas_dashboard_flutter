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

// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  final messages = _notInlinedMessages(_notInlinedMessages);

  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "aboutAuthor": MessageLookupByLibrary.simpleMessage("关于作者"),
        "anErrorOccurred": MessageLookupByLibrary.simpleMessage("一个异常发生了"),
        "appName": MessageLookupByLibrary.simpleMessage("Paas 仪表盘"),
        "basic": MessageLookupByLibrary.simpleMessage("基础信息"),
        "brokersName": MessageLookupByLibrary.simpleMessage("Pulsar 实例"),
        "byte": MessageLookupByLibrary.simpleMessage("比特"),
        "cancel": MessageLookupByLibrary.simpleMessage("取消"),
        "clearBacklog": MessageLookupByLibrary.simpleMessage("清理积压"),
        "codeQuery": MessageLookupByLibrary.simpleMessage("code 查询"),
        "confirm": MessageLookupByLibrary.simpleMessage("确认"),
        "confirmClearBacklog": MessageLookupByLibrary.simpleMessage("确认清理积压吗？"),
        "confirmDeleteQuestion": MessageLookupByLibrary.simpleMessage("确认删除吗？"),
        "consume": MessageLookupByLibrary.simpleMessage("消费"),
        "consumer": MessageLookupByLibrary.simpleMessage("消费者"),
        "consumerList": MessageLookupByLibrary.simpleMessage("消费者列表"),
        "delete": MessageLookupByLibrary.simpleMessage("删除"),
        "deleteNamespace": MessageLookupByLibrary.simpleMessage("删除命名空间"),
        "deleteTenant": MessageLookupByLibrary.simpleMessage("删除租户"),
        "deleteTopic": MessageLookupByLibrary.simpleMessage("删除 Topic"),
        "detail": MessageLookupByLibrary.simpleMessage("详细信息"),
        "email": MessageLookupByLibrary.simpleMessage("邮箱"),
        "entryId": MessageLookupByLibrary.simpleMessage("编号"),
        "execute": MessageLookupByLibrary.simpleMessage("执行"),
        "forceDelete": MessageLookupByLibrary.simpleMessage("强制删除"),
        "isLeader": MessageLookupByLibrary.simpleMessage("是否是主节点"),
        "languageSettings": MessageLookupByLibrary.simpleMessage("语言设置"),
        "messageList": MessageLookupByLibrary.simpleMessage("消息列表"),
        "name": MessageLookupByLibrary.simpleMessage("名称"),
        "namespace": MessageLookupByLibrary.simpleMessage("命名空间"),
        "namespaceName": MessageLookupByLibrary.simpleMessage("命名空间名称"),
        "namespaces": MessageLookupByLibrary.simpleMessage("命名空间列表"),
        "partitionList": MessageLookupByLibrary.simpleMessage("partition 列表"),
        "partitionNum": MessageLookupByLibrary.simpleMessage("partition 个数"),
        "produce": MessageLookupByLibrary.simpleMessage("生产"),
        "producer": MessageLookupByLibrary.simpleMessage("生产者"),
        "producerList": MessageLookupByLibrary.simpleMessage("生产者列表"),
        "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
        "searchByMessageId": MessageLookupByLibrary.simpleMessage("通过messageId查询消息，格式ledgerId entryId，按enter键进行查询。"),
        "searchByMessageIdWithHint": MessageLookupByLibrary.simpleMessage(
            "通过messageId查询消息，单条查询格式ledgerId entryId，范围查询格式位ledgerId entryId entryId，按enter键进行查询。"),
        "searchByNamespace": MessageLookupByLibrary.simpleMessage("按命名空间名称搜索"),
        "searchByTenant": MessageLookupByLibrary.simpleMessage("按租户名称搜索"),
        "searchByTimestampWithHint": MessageLookupByLibrary.simpleMessage("通过时间戳查询消息Id， 按enter键进行查询"),
        "searchByTopic": MessageLookupByLibrary.simpleMessage("按 Topic 名称搜索"),
        "second": MessageLookupByLibrary.simpleMessage("秒"),
        "settings": MessageLookupByLibrary.simpleMessage("设置"),
        "sqlQuery": MessageLookupByLibrary.simpleMessage("sql 查询"),
        "submit": MessageLookupByLibrary.simpleMessage("提交"),
        "subscription": MessageLookupByLibrary.simpleMessage("订阅"),
        "subscriptionList": MessageLookupByLibrary.simpleMessage("订阅列表"),
        "subscriptionName": MessageLookupByLibrary.simpleMessage("订阅名称"),
        "tenant": MessageLookupByLibrary.simpleMessage("租户"),
        "tenantName": MessageLookupByLibrary.simpleMessage("租户名称"),
        "tenants": MessageLookupByLibrary.simpleMessage("租户列表"),
        "topicDetail": MessageLookupByLibrary.simpleMessage("主题详情"),
        "topicName": MessageLookupByLibrary.simpleMessage("Topic 名称"),
        "topics": MessageLookupByLibrary.simpleMessage("Topic 列表"),
        "unit": MessageLookupByLibrary.simpleMessage("单位"),
        "versionName": MessageLookupByLibrary.simpleMessage("版本")
      };
}
