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
import 'package:paas_dashboard_flutter/api/http_util.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/persistent/po/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_form_state.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_list_view_model.dart';
import 'package:provider/provider.dart';

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
    var datatable = DataTable(
      showCheckboxColumn: false,
      columns: [
        DataColumn(label: Text('Id')),
        DataColumn(label: Text('Name')),
        DataColumn(label: Text('Host')),
        DataColumn(label: Text('Port')),
        DataColumn(label: Text('FunctionHost')),
        DataColumn(label: Text('FunctionPort')),
        DataColumn(label: Text('EnableTls')),
        DataColumn(label: Text('Function EnableTLS')),
        DataColumn(label: Text('Ca File')),
        DataColumn(label: Text('Client Certificate File')),
        DataColumn(label: Text('Client Key File')),
        DataColumn(label: Text('Client Key Password')),
        DataColumn(label: Text('Modify instance')),
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
                    DataCell(Text(itemRow.enableTls.toString())),
                    DataCell(Text(itemRow.functionEnableTls.toString())),
                    DataCell(Text(itemRow.caFile.toString())),
                    DataCell(Text(itemRow.clientCertFile.toString())),
                    DataCell(Text(itemRow.clientKeyFile.toString())),
                    DataCell(Text(itemRow.clientKeyPassword.toString())),
                    DataCell(Row(
                      children: [
                        updateInstanceButton(context, itemRow.toPulsarFormDto()),
                        DataCellUtil.newDelDataButton(() {
                          vm.deletePulsar(itemRow.id);
                          HttpUtil.remove(SERVER.PULSAR, itemRow.id);
                        })
                      ],
                    ))
                  ]))
          .toList(),
    );
    var tableView = SingleChildScrollView(
      physics: ScrollPhysics(),
      primary: true,
      scrollDirection: Axis.horizontal,
      child: datatable,
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
        PulsarInstancePo.fieldList(),
        context,
        (data) => vm.createPulsar(
            data[1], data[2], data[3], data[4], data[5], data[6], data[7], data[8], data[9], data[10], data[11]));

    var body = ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      controller: ScrollController(),
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
        Scrollbar(radius: Radius.circular(10), thickness: 10, child: tableView)
      ],
    );

    return Scaffold(
        appBar: AppBar(
          title: Text('Pulsar Dashboard'),
        ),
        body: body);
  }

  Widget updateInstanceButton(BuildContext context, PulsarFormDto formDto) {
    final vm = Provider.of<PulsarInstanceListViewModel>(context, listen: false);
    return new PulsarForm((formDto) {
      vm.updatePulsar(
          formDto.id,
          formDto.name,
          formDto.host,
          formDto.port,
          formDto.functionHost,
          formDto.functionPort,
          formDto.enableTls,
          formDto.functionEnableTls,
          formDto.caFile,
          formDto.clientCertFile,
          formDto.clientKeyFile,
          formDto.clientKeyPassword);
      HttpUtil.remove(SERVER.PULSAR, formDto.id);
    }, formDto);
  }

  Widget createInstanceButton(BuildContext context) {
    final vm = Provider.of<PulsarInstanceListViewModel>(context, listen: false);
    return new PulsarForm((formDto) {
      vm.createPulsar(
          formDto.name,
          formDto.host,
          formDto.port,
          formDto.functionHost,
          formDto.functionPort,
          formDto.enableTls,
          formDto.functionEnableTls,
          formDto.caFile,
          formDto.clientCertFile,
          formDto.clientKeyFile,
          formDto.clientKeyPassword);
    }, null);
  }
}
