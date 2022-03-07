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
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_list_view_model.dart';
import 'package:provider/provider.dart';
import 'package:paas_dashboard_flutter/persistent/po/mongo_instance_po.dart';

class MongoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MongoPageState();
  }
}

class _MongoPageState extends State<MongoPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MongoInstanceListViewModel>(context, listen: false).fetchMongoInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MongoInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchMongoInstances();
          });
        },
        child: Text(S.of(context).refresh));
    var exportButton = FormUtil.createExportButton(MongoInstancePo.fieldList().toList(),
        vm.instances.map((e) => e.mongoInstancePo.toMap().values.toList()).toList(), context);
    var importButton = FormUtil.createImportButton(
        MongoInstancePo.fieldList(), context, (data) => vm.createMongo(data[1], data[2], data[3], data[4]));
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
          child: Text('Mongo Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Addr')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.MongoInstance, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.addr)),
                          DataCell(Text(itemRow.username)),
                          DataCellUtil.newDelDataCell(() {
                            vm.deleteMongo(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Mongo Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<MongoInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Addr'),
      FormFieldDef('Username'),
      FormFieldDef('Password'),
    ];
    return FormUtil.createButton4("Mongo Instance", list, context, (name, addr, username, password) {
      vm.createMongo(name, addr, username, password);
    });
  }

  ButtonStyleButton createExportButton(BuildContext context) {
    final vm = Provider.of<MongoInstanceListViewModel>(context, listen: false);
    vm.fetchMongoInstances();
    return FormUtil.createExportButton(vm.instances[0].mongoInstancePo.toMap().keys.toList(),
        vm.instances.map((e) => e.mongoInstancePo.toMap().values.toList()).toList(), context);
  }
}
