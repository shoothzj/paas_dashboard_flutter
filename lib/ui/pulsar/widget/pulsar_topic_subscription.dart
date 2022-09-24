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
import 'package:paas_dashboard_flutter/ui/component/clear_backlog_button.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_subscription_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicSubscriptionWidget extends StatefulWidget {
  const PulsarTopicSubscriptionWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarTopicSubscriptionWidgetState();
  }
}

class PulsarTopicSubscriptionWidgetState extends State<PulsarTopicSubscriptionWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTopicSubscriptionViewModel>(context, listen: false);
    vm.fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicSubscriptionViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var subscriptionFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).subscriptionName)),
            const DataColumn(label: Text('MsgBacklog')),
            const DataColumn(label: Text('MsgRateOut')),
            DataColumn(label: Text(S.of(context).clearBacklog)),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.subscriptionName),
                    ),
                    DataCell(
                      Text(data.backlog.toString()),
                    ),
                    DataCell(
                      Text(data.rateOut.toString()),
                    ),
                    DataCell(ClearBacklogButton(() {
                      vm.clearBacklog(data.subscriptionName);
                    })),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchSubscriptions();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton],
          ),
        ),
        Text(
          S.of(context).subscriptionList,
          style: const TextStyle(fontSize: 22),
        ),
        subscriptionFuture
      ],
    );
    return body;
  }
}
