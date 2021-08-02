import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/tab/pulsar_basic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/tab/pulsar_details.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/tab/pulsar_message_query.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_cluster_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:provider/provider.dart';

class PulsarInstanceScreen extends StatefulWidget {
  PulsarInstanceScreen();

  @override
  State<StatefulWidget> createState() {
    return new _PulsarInstanceState();
  }
}

class _PulsarInstanceState extends State<PulsarInstanceScreen> {
  _PulsarInstanceState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarInstanceViewModel>(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pulsar ${vm.name} Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Basic",
              ),
              Tab(text: "Details"),
              Tab(text: "MessageQuery"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => PulsarClusterViewModel(vm.pulsarInstancePo),
              child: PulsarBasicWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => vm.deepCopy(),
              child: PulsarTenantsWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => vm.deepCopy(),
              child: PulsarMessageQueryWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
