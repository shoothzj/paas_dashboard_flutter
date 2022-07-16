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
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_basic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicBasicWidget extends StatefulWidget {
  PulsarPartitionedTopicBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicBasicWidgetState();
  }
}

class PulsarPartitionedTopicBasicWidgetState extends State<PulsarPartitionedTopicBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarPartitionedTopicBasicViewModel>(context, listen: false);
    vm.fetchPartitions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicBasicViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var updatePartitionButton = modifyPartitionTopicButton(context);
    var createMissPartitionButton = TextButton(
        onPressed: () {
          vm.createMissTopicPartition(vm.topic);
          AlertUtil.createDialog(S.of(context).success, context);
        },
        child: Text(S.of(context).createMissPartition));
    var refreshButton = TextButton(onPressed: () {}, child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton, updatePartitionButton, createMissPartitionButton],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'partition num is ${vm.partitionNum}',
                style: new TextStyle(fontSize: 20),
              )
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'storageSize :  ${vm.storageSize}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgRateIn :  ${vm.msgRateIn}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgRateOut :  ${vm.msgRateOut}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgInCounter :  ${vm.msgInCounter}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgOutCounter :  ${vm.msgOutCounter}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
    return body;
  }

  ButtonStyleButton modifyPartitionTopicButton(BuildContext context) {
    var list = [FormFieldDef('New Partition Number')];
    return FormUtil.updateButton1("Topic Partitions", list, context, (partition) async {
      final vm = Provider.of<PulsarPartitionedTopicBasicViewModel>(context, listen: false);
      vm.modifyTopicPartition(vm.topic, int.parse(partition));
    });
  }
}
