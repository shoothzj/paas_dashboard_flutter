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
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_basic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSourceBasicWidget extends StatefulWidget {
  const PulsarSourceBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarSourceBasicWidgetState();
  }
}

class PulsarSourceBasicWidgetState extends State<PulsarSourceBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarSourceBasicViewModel>(context, listen: false);
    vm.fetch();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarSourceBasicViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var refreshButton = TextButton(onPressed: () {}, child: Text(S.of(context).refresh));
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
                'output is ${vm.topicName}',
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
                'configs is ${vm.configs}',
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
                'archive is ${vm.archive}',
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
