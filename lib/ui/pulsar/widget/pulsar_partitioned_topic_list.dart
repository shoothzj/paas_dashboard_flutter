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
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicListWidget extends StatefulWidget {
  const PulsarPartitionedTopicListWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarPartitionedTopicListWidgetState();
  }
}

class PulsarPartitionedTopicListWidgetState extends State<PulsarPartitionedTopicListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarPartitionedTopicListViewModel>(context, listen: false);
    vm.fetchTopics();
    searchTextController.addListener(() {
      vm.filter(searchTextController.text);
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarPartitionedTopic, arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                SelectableText(item.topic),
              ),
              DataCellUtil.newForceDelDataCell((force) {
                vm.deletePartitionedTopic(item.topic, force);
              }),
            ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).topicName)),
            DataColumn(label: Text(S.of(context).deleteTopic)),
          ],
          source: vm),
    );
    var formButton = createPartitionTopicButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchTopics();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton],
          ),
        ),
        SearchableTitle(S.of(context).topics, S.of(context).searchByTopic, searchTextController),
        topicsTable
      ],
    );
    return body;
  }

  ButtonStyleButton createPartitionTopicButton(BuildContext context) {
    var list = [FormFieldDef('Topic Name'), FormFieldDef('Partition Number')];
    return FormUtil.createButton2("Partitioned Topic", list, context, (topic, partition) async {
      final vm = Provider.of<PulsarNamespaceViewModel>(context, listen: false);
      vm.createPartitionedTopic(topic, int.parse(partition));
    });
  }
}
