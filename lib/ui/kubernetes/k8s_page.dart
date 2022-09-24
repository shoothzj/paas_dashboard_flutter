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
import 'package:paas_dashboard_flutter/persistent/po/k8s_instance_po.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/kubernetes/k8s_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class K8sPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _K8sPageState();
  }
}

class _K8sPageState extends State<K8sPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<K8sInstanceListViewModel>(context, listen: false).fetchKubernetesInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<K8sInstanceListViewModel>(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchKubernetesInstances();
          });
        },
        child: Text(S.of(context).refresh));
    var exportButton = FormUtil.createExportButton(K8sInstancePo.fieldList().toList(),
        vm.instances.map((e) => e.k8sInstancePo.toMap().values.toList()).toList(), context);
    var body = ListView(
      children: [
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton, exportButton],
          ),
        ),
        const Center(
          child: Text('Kubernetes Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: const [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(onSelectChanged: (bool? selected) {}, cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCellUtil.newDelDataCell(() {
                        vm.deleteKubernetes(itemRow.id);
                      }),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: const Text('Kubernetes Dashboard'),
        ),
        body: body);
  }
}
