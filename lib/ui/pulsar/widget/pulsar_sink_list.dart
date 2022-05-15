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
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSinkListWidget extends StatefulWidget {
  PulsarSinkListWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarSinkListWidgetState();
  }
}

class PulsarSinkListWidgetState extends State<PulsarSinkListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarSinkListViewModel>(context, listen: false);
    vm.fetchSinks();
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
    final vm = Provider.of<PulsarSinkListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarSink, arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.sinkName),
              ),
              DataCellUtil.newDelDataCell(() {
                vm.deleteSink(item.sinkName);
              }),
            ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Sink")),
            DataColumn(label: Text(S.of(context).delete)),
          ],
          source: vm),
    );
    var formButton = createSinkButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchSinks();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton],
          ),
        ),
        SearchableTitle("sink list", "search by sink name", searchTextController),
        topicsTable
      ],
    );
    return body;
  }

  ButtonStyleButton createSinkButton(BuildContext context) {
    var list = [
      FormFieldDef('Sink Name'),
      FormFieldDef('Sub Name'),
      FormFieldDef('Input Topic'),
      FormFieldDef('Sink type'),
      FormFieldDef('Config')
    ];
    return FormUtil.createButton5("Sink", list, context, (sinkName, subName, inputTopic, sinkType, config) async {
      final vm = Provider.of<PulsarSinkListViewModel>(context, listen: false);
      vm.createSink(sinkName, subName, inputTopic, sinkType, config);
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Dart 目前不支持复杂ContentType请求，Curl命令已复制到剪切版'),
        ),
      );
    });
  }
}
