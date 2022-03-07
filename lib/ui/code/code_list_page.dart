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
import 'package:paas_dashboard_flutter/persistent/po/code_instance_po.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/code/code_list_view_model.dart';
import 'package:provider/provider.dart';

class CodeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CodeListPageState();
  }
}

class _CodeListPageState extends State<CodeListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CodeListViewModel>(context, listen: false).fetchCodeList();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CodeListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchCodeList();
          });
        },
        child: Text(S.of(context).refresh));
    var exportButton = FormUtil.createExportButton(
        CodePo.fieldList().toList(), vm.instances.map((e) => e.codePo.toMap().values.toList()).toList(), context);
    var importButton =
        FormUtil.createImportButton(CodePo.fieldList(), context, (data) => vm.createCode(data[1], data[2]));
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
          child: Text('Code List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Delete code')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.CodeExecute, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.code)),
                          DataCellUtil.newDelDataCell(() {
                            vm.deleteCode(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Code Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<CodeListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Code Name'),
      FormFieldDef('Code'),
    ];
    return FormUtil.createButton2("Code", list, context, (name, code) {
      vm.createCode(name, code);
    });
  }
}
