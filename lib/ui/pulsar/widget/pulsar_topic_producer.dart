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
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_producer_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicProducerWidget extends StatefulWidget {
  const PulsarTopicProducerWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarTopicProducerWidgetState();
  }
}

class PulsarTopicProducerWidgetState extends State<PulsarTopicProducerWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTopicProducerViewModel>(context, listen: false);
    vm.fetchProducers();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicProducerViewModel>(context);
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
          columns: const [
            DataColumn(label: Text('ProducerName')),
            DataColumn(label: Text('MsgRateIn')),
            DataColumn(label: Text('MsgThroughputIn')),
            DataColumn(label: Text('ClientVersion')),
            DataColumn(label: Text('AverageMsgSize')),
            DataColumn(label: Text('Address')),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.producerName),
                    ),
                    DataCell(
                      Text(data.rateIn.toString()),
                    ),
                    DataCell(
                      Text(data.throughputIn.toString()),
                    ),
                    DataCell(
                      Text(data.clientVersion.toString()),
                    ),
                    DataCell(
                      Text(data.averageMsgSize.toString()),
                    ),
                    DataCell(
                      Text(data.address.toString()),
                    ),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchProducers();
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
          S.of(context).producerList,
          style: const TextStyle(fontSize: 22),
        ),
        subscriptionFuture,
      ],
    );
    return body;
  }
}
