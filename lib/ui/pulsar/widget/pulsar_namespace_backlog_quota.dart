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
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_backlog_quota_view_model.dart';
import 'package:provider/provider.dart';

class PulsarNamespaceBacklogQuotaWidget extends StatefulWidget {
  PulsarNamespaceBacklogQuotaWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarNamespaceBacklogQuotaWidgetState();
  }
}

class PulsarNamespaceBacklogQuotaWidgetState extends State<PulsarNamespaceBacklogQuotaWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarNamespaceBacklogQuotaViewModel>(context, listen: false);
    vm.fetchBacklogQuota();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarNamespaceBacklogQuotaViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processLoadException(vm, context);
    var limitSizeEditingController = TextEditingController(text: vm.limitSizeDisplayStr);
    var limitTimeEditingController = TextEditingController(text: vm.limitTimeDisplayStr);
    var policyEditingController = TextEditingController(text: vm.retentionPolicyDisplayStr);
    var formButton = TextButton(
        onPressed: () {
          vm.limitSizeDisplayStr = limitSizeEditingController.value.text;
          vm.limitTimeDisplayStr = limitTimeEditingController.value.text;
          vm.retentionPolicyDisplayStr = policyEditingController.value.text;
          vm.updateBacklogQuota();
        },
        child: Text(S.of(context).submit));
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchBacklogQuota();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton, formButton],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "LimitSize"),
            controller: limitSizeEditingController,
          ),
        ),
        Container(
          child: Text("${S.of(context).unit}: ${S.of(context).byte}"),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "LimitTime"),
            controller: limitTimeEditingController,
          ),
        ),
        Container(
          child: Text("${S.of(context).unit}: ${S.of(context).second}"),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "Policy"),
            controller: policyEditingController,
          ),
        ),
        Container(
          child: SelectableText(
            "Policy enum: {producer_request_hold, producer_exception, consumer_backlog_eviction}",
            toolbarOptions: ToolbarOptions(paste: true),
          ),
        ),
      ],
    );
    return body;
  }
}
