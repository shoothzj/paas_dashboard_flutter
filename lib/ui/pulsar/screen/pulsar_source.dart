import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_source_basic.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_basic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSourceScreen extends StatefulWidget {
  PulsarSourceScreen();

  @override
  State<StatefulWidget> createState() {
    return new _PulsarSourceScreenState();
  }
}

class _PulsarSourceScreenState extends State<PulsarSourceScreen> {
  _PulsarSourceScreenState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarSourceViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Pulsar Source ${S.of(context).tenant} ${vm.tenant} -> ${S.of(context).namespace} ${vm.namespace} -> Topic ${vm.sourceName}'),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).basic),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => PulsarSourceBasicViewModel(
                  vm.pulsarInstancePo,
                  vm.tenantResp,
                  vm.namespaceResp,
                  vm.sourceResp),
              child: PulsarSourceBasicWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
