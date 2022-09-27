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
import 'package:paas_dashboard_flutter/persistent/po/bk_instance_po.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class BkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BkPageState();
  }
}

class _BkPageState extends State<BkPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BkInstanceListViewModel>(context, listen: false).fetchBkInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BkInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchBkInstances();
          });
        },
        child: Text(S.of(context).refresh));
    var exportButton = FormUtil.exportButton('bk-instances', BkInstancePo.fieldList().toList(),
        vm.instances.map((e) => e.bkInstancePo.toMap().values.toList()).toList(), context);
    var importButton =
        FormUtil.importButton(BkInstancePo.fieldList(), context, (data) => vm.createBk(data[1], data[2], data[3]));
    var body = ListView(
      children: [
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton, exportButton, importButton],
          ),
        ),
        const Center(
          child: Text('Bookkeeper Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Port')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(onSelectChanged: (bool? selected) {}, cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCell(Text(itemRow.host)),
                      DataCell(Text(itemRow.port.toString())),
                      DataCellUtil.newDelDataCell(() {
                        vm.deleteBk(itemRow.id);
                      }),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Bookkeeper Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<BkInstanceListViewModel>(context, listen: false);
    var list = [FormFieldDef('Instance Name'), FormFieldDef('Instance Host'), FormFieldDef('Instance Port')];
    return FormUtil.createButton3("Bookkeeper Instance", list, context, (name, host, port) {
      vm.createBk(name, host, int.parse(port));
    });
  }
}
