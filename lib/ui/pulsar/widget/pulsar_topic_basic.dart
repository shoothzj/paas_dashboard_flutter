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
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_basic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicBasicWidget extends StatefulWidget {
  const PulsarTopicBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarTopicBasicWidgetState();
  }
}

class PulsarTopicBasicWidgetState extends State<PulsarTopicBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTopicBasicViewModel>(context, listen: false);
    vm.fetchPartitions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicBasicViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchPartitions();
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
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'Broker :  ${vm.brokerUrl}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'StorageSize :  ${vm.storageSize}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgRateIn :  ${vm.msgRateIn}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgRateOut :  ${vm.msgRateOut}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgInCounter :  ${vm.msgInCounter}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'MsgOutCounter :  ${vm.msgOutCounter}',
                style: const TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
    return body;
  }
}
