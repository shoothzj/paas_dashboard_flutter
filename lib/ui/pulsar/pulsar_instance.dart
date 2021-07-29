import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/tab/pulsar_message_query.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/tab/pulsar_basic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/tab/pulsar_details.dart';

class PulsarInstanceScreen extends StatefulWidget {
  final PulsarInstanceContext instanceContext;

  PulsarInstanceScreen(this.instanceContext);

  @override
  State<StatefulWidget> createState() {
    return new _PulsarInstanceState(instanceContext);
  }
}

class _PulsarInstanceState extends State<PulsarInstanceScreen> {
  final PulsarInstanceContext instanceContext;

  _PulsarInstanceState(this.instanceContext);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pulsar ' + instanceContext.name + ' Dashboard'),
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
            new PulsarBasicWidget(instanceContext),
            new PulsarTenantsWidget(instanceContext),
            new PulsarMessageQueryWidget(instanceContext),
          ],
        ),
      ),
    );
  }
}
