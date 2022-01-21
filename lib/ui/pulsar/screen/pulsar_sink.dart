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
              create: (context) =>
                  PulsarSinkBasicViewModel(vm.pulsarInstancePo, vm.tenantResp, vm.namespaceResp, vm.sinkResp),
              child: PulsarSinkBasicWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
