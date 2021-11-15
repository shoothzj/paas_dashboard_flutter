import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_partitioned_topic_basic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_partitioned_topic_produce.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_partitioned_topic_subscription.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_basic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_produce_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_subscription_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopic extends StatefulWidget {
  PulsarPartitionedTopic();

  @override
  State<StatefulWidget> createState() {
    return new _PulsarPartitionedTopicState();
  }
}

class _PulsarPartitionedTopicState extends State<PulsarPartitionedTopic> {
  _PulsarPartitionedTopicState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicViewModel>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pulsar ${vm.topic} Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Basic"),
              Tab(text: "Subscription"),
              Tab(text: "Produce"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => PulsarPartitionedTopicBasicViewModel(
                  vm.pulsarInstancePo,
                  vm.tenantResp,
                  vm.namespaceResp,
                  vm.topicResp),
              child: PulsarPartitionedTopicBasicWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) =>
                  new PulsarPartitionedTopicSubscriptionViewModel(
                      vm.pulsarInstancePo,
                      vm.tenantResp,
                      vm.namespaceResp,
                      vm.topicResp),
              child: PulsarPartitionedTopicSubscriptionWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => PulsarPartitionedTopicProduceViewModel(
                  vm.pulsarInstancePo,
                  vm.tenantResp,
                  vm.namespaceResp,
                  vm.topicResp),
              child: PulsarPartitionedTopicProduceWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
