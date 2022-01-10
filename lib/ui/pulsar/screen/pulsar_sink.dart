import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/widget/pulsar_sink_basic.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_basic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSinkScreen extends StatefulWidget {
  PulsarSinkScreen();

  @override
  State<StatefulWidget> createState() {
    return new _PulsarSinkScreenState();
  }
}

class _PulsarSinkScreenState extends State<PulsarSinkScreen> {
  _PulsarSinkScreenState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarSinkViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              'Pulsar Sink ${S.of(context).tenant} ${vm.tenant} -> ${S.of(context).namespace} ${vm.namespace} -> Topic ${vm.sinkName}'),
          bottom: TabBar(
            tabs: [
              Tab(text: S.of(context).basic),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => PulsarSinkBasicViewModel(vm.pulsarInstancePo,
                  vm.tenantResp, vm.namespaceResp, vm.sinkResp),
              child: PulsarSinkBasicWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
