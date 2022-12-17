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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/component/clear_backlog_button.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_subscription_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicSubscriptionWidget extends StatefulWidget {
  const PulsarPartitionedTopicSubscriptionWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarPartitionedTopicSubscriptionWidgetState();
  }
}

class PulsarPartitionedTopicSubscriptionWidgetState extends State<PulsarPartitionedTopicSubscriptionWidget> {
  final resetCursorByTimeTextController = TextEditingController();
  final ledgerIdTextController = TextEditingController();
  final entryIdTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    resetCursorByTimeTextController.addListener(() {});
    ledgerIdTextController.addListener(() {});
    entryIdTextController.addListener(() {});
    final vm = Provider.of<PulsarPartitionedTopicSubscriptionViewModel>(context, listen: false);
    vm.fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicSubscriptionViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);

    var timeField = TextField(
      decoration: InputDecoration(
        fillColor: Colors.green,
        labelText: Text(S.of(context).resetCursorWithHint).data,
        hintText: Text(S.of(context).resetCursorWithHint).data,
      ),
      controller: resetCursorByTimeTextController,
    );

    var timeButton = TextButton(
      onPressed: () {
        DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
          print("change $date");
        }, onConfirm: (date) {
          resetCursorByTimeTextController.text = date.millisecondsSinceEpoch.toString();
        }, currentTime: DateTime.now(), locale: LocaleType.zh);
      },
      child: Text(S.of(context).timePick),
    );

    var subscriptionFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).subscriptionName)),
            const DataColumn(label: Text('MsgBacklog')),
            const DataColumn(label: Text('MsgRateOut')),
            DataColumn(label: Text(S.of(context).clearBacklog)),
            DataColumn(label: Text(S.of(context).resetCursor)),
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
                    DataCell(TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text(
                                    S.of(context).resetCursor,
                                    textAlign: TextAlign.center,
                                  ),
                                  actions: <Widget>[
                                    timeField,
                                    timeButton,
                                    TextButton(
                                      child: Text(
                                        S.of(context).cancel,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        S.of(context).confirm,
                                      ),
                                      onPressed: () {
                                        vm.resetCursorByTimestamp(data.subscriptionName,
                                            int.parse(resetCursorByTimeTextController.value.text));
                                        Navigator.of(context).pop();
                                        AlertUtil.createDialog(S.of(context).success, context);
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Text(
                          S.of(context).resetCursor,
                        ))),
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
