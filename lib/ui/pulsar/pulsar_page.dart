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
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';

class PulsarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PulsarPageState();
  }
}

class _PulsarPageState extends State<PulsarPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PulsarInstanceListViewModel>(context, listen: false).fetchPulsarInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarInstanceListViewModel>(context);
    var tableView = SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columns: [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Host')),
          DataColumn(label: Text('Port')),
          DataColumn(label: Text('FunctionHost')),
          DataColumn(label: Text('FunctionPort')),
          DataColumn(label: Text('Delete instance')),
        ],
        rows: vm.instances
            .map((itemRow) => DataRow(
                    onSelectChanged: (bool? selected) {
                      Navigator.pushNamed(context, PageRouteConst.PulsarInstance, arguments: itemRow.deepCopy());
                    },
                    cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCell(Text(itemRow.host)),
                      DataCell(Text(itemRow.port.toString())),
                      DataCell(Text(itemRow.functionHost)),
                      DataCell(Text(itemRow.functionPort.toString())),
                      DataCellUtil.newDelDataCell(() {
                        vm.deletePulsar(itemRow.id);
                      }),
                    ]))
            .toList(),
      ),
    );
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchPulsarInstances();
        },
        child: Text(S.of(context).refresh));
    var exportButton = FormUtil.createExportButton(PulsarInstancePo.fieldList().toList(),
        vm.instances.map((e) => e.pulsarInstancePo.toMap().values.toList()).toList(), context);
    var importButton = FormUtil.createImportButton(
        PulsarInstancePo.fieldList(), context, (data) => vm.createPulsar(data[1], data[2], data[3], data[4], data[5]));
    var body = ListView(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton, exportButton, importButton],
          ),
        ),
        Center(
          child: Text('Pulsar Instance List'),
        ),
        tableView
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Pulsar Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<PulsarInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Host'),
      FormFieldDef('Port'),
      FormFieldDef('Function Host'),
      FormFieldDef('Function Port'),
    ];
    return FormUtil.createButton5("Pulsar Instance", list, context, (name, host, port, functionHost, functionPort) {
      vm.createPulsar(name, host, int.parse(port), functionHost, int.parse(functionPort));
    });
  }
}
