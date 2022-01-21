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
import 'package:paas_dashboard_flutter/vm/mysql/mysql_instance_list_view_model.dart';
import 'package:provider/provider.dart';

/// MySQL Instance List Windows
class MysqlPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MysqlPageState();
  }
}

class _MysqlPageState extends State<MysqlPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MysqlInstanceListViewModel>(context, listen: false).fetchMysqlInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MysqlInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchMysqlInstances();
          });
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton],
          ),
        ),
        Center(
          child: Text('Mysql Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Host')),
              DataColumn(label: Text('Port')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.MysqlInstance, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.host)),
                          DataCell(Text(itemRow.port.toString())),
                          DataCell(Text(itemRow.username)),
                          DataCellUtil.newDelDataCell(() {
                            vm.deleteMysql(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Mysql Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<MysqlInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Host'),
      FormFieldDef('Port'),
      FormFieldDef('Username'),
      FormFieldDef('Password'),
    ];
    return FormUtil.createButton5("Mysql Instance", list, context, (name, host, port, username, password) {
      vm.createMysql(name, host, int.parse(port), username, password);
    });
  }
}
