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
import 'package:paas_dashboard_flutter/persistent/po/redis_instance_po.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/redis/redis_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class RedisPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RedisPageState();
  }
}

class _RedisPageState extends State<RedisPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RedisInstanceListViewModel>(context, listen: false).fetchRedisInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RedisInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchRedisInstances();
          });
        },
        child: Text(S.of(context).refresh));
    var exportButton = FormUtil.exportButton('redis-instances', RedisInstancePo.fieldList(),
        vm.instances.map((e) => e.redisInstancePo.toMap().values.toList()).toList(), context);
    var importButton = FormUtil.importButton(RedisInstancePo.fieldList(), context,
        (data) => vm.createRedis(data[1].toString(), data[2], data[3].toString(), data[4].toString()));
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
          child: Text('Redis Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('IP')),
              DataColumn(label: Text('Port')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.RedisInstance, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.ip)),
                          DataCell(Text(itemRow.port.toString())),
                          DataCellUtil.newDelDataCell(() {
                            vm.deleteRedis(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Redis Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<RedisInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('IP'),
      FormFieldDef('Port'),
      FormFieldDef('Password'),
    ];
    return FormUtil.createButton4("Redis Instance", list, context, (name, ip, port, password) {
      vm.createRedis(name, ip, port, password);
    });
  }
}
