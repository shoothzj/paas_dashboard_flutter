import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_namespace_backlog_quota.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_namespace_policies.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_partitioned_topic_list.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_sink_list.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_source_list.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_topic_list.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_backlog_quota_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_policies_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarNamespaceScreen extends StatefulWidget {
  PulsarNamespaceScreen();

  @override
  State<StatefulWidget> createState() {
    return new PulsarNamespaceScreenState();
  }
}

class PulsarNamespaceScreenState extends State<PulsarNamespaceScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarNamespaceViewModel>(context);
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Pulsar ${S.of(context).tenant} ${vm.tenant} -> ${S.of(context).namespace} ${vm.namespace}'),
          bottom: TabBar(
            tabs: [
              Tab(text: "BacklogQuota"),
              Tab(text: "PartitionedTopics"),
              Tab(text: "Topics"),
              Tab(text: "Source"),
              Tab(text: "Sink"),
              Tab(text: "Policies"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => PulsarNamespaceBacklogQuotaViewModel(
                  vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp),
              child: PulsarNamespaceBacklogQuotaWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => PulsarPartitionedTopicListViewModel(
                  vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp),
              child: PulsarPartitionedTopicListWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => PulsarTopicListViewModel(
                  vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp),
              child: PulsarTopicListWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => PulsarSourceListViewModel(
                  vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp),
              child: PulsarSourceListWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => PulsarSinkListViewModel(
                  vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp),
              child: PulsarSinkListWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => PulsarNamespacePoliciesViewModel(
                  vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp),
              child: PulsarNamespacePoliciesWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
