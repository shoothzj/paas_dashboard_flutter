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

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_basic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_consume.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_consumer.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_produce.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_producer.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_subscription.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_basic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_consume_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_consumer_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_produce_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_producer_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_subscription_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopic extends StatefulWidget {
  const PulsarTopic();

  @override
  State<StatefulWidget> createState() {
    return _PulsarTopicState();
  }
}

class _PulsarTopicState extends State<PulsarTopic> {
  _PulsarTopicState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicViewModel>(context);
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Pulsar Topic ${S.of(context).tenant} ${vm.tenant} -> ${S.of(context).namespace} ${vm.namespace} -> Topic ${vm.topic}'),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).basic),
              Tab(text: S.of(context).subscription),
              Tab(text: S.of(context).consumer),
              Tab(text: S.of(context).producer),
              Tab(text: S.of(context).consume),
              Tab(text: S.of(context).produce),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) =>
                  PulsarTopicBasicViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.topicResp),
              child: const PulsarTopicBasicWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) =>
                  PulsarTopicSubscriptionViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.topicResp),
              child: const PulsarTopicSubscriptionWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) =>
                  PulsarTopicConsumerViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.topicResp),
              child: const PulsarTopicConsumerWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) =>
                  PulsarTopicProducerViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.topicResp),
              child: const PulsarTopicProducerWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) =>
                  PulsarTopicConsumeViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.topicResp),
              child: const PulsarTopicConsumeWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) =>
                  PulsarTopicProduceViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.topicResp),
              child: const PulsarTopicProduceWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
