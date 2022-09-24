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
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_produce_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicProduceWidget extends StatefulWidget {
  const PulsarPartitionedTopicProduceWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarPartitionedTopicProduceWidgetState();
  }
}

class PulsarPartitionedTopicProduceWidgetState extends State<PulsarPartitionedTopicProduceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicProduceViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);

    var produceMsgButton = createInstanceButton(context);
    var body = ListView(
      children: [
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [produceMsgButton],
          ),
        ),
      ],
    );
    return Scaffold(body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicProduceViewModel>(context, listen: false);
    var list = [
      FormFieldDef('message key'),
      FormFieldDef('message value'),
    ];
    return FormUtil.createButton2NoText("Send Message To Pulsar", list, context, (key, value) {
      vm.sendMsg(key, value);
    });
  }
}
