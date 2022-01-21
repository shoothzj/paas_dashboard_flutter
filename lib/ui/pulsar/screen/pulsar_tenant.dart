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
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTenantScreen extends StatefulWidget {
  PulsarTenantScreen();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTenantScreenState();
  }
}

class PulsarTenantScreenState extends State<PulsarTenantScreen> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTenantViewModel>(context, listen: false);
    vm.fetchNamespaces();
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
    final vm = Provider.of<PulsarTenantViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarNamespace, arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.namespace),
              ),
              DataCellUtil.newDelDataCell(() {
                vm.deleteNamespace(item.namespace);
              }),
            ]));
    var formButton = createNamespace(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchNamespaces();
        },
        child: Text(S.of(context).refresh));
    var listView = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton],
          ),
        ),
        SearchableTitle(S.of(context).namespaces, S.of(context).searchByNamespace, searchTextController),
        SingleChildScrollView(
          child: PaginatedDataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text(S.of(context).namespaceName)),
                DataColumn(label: Text(S.of(context).deleteNamespace)),
              ],
              source: vm),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulsar ${S.of(context).tenant} ${vm.tenant}'),
      ),
      body: listView,
    );
  }

  ButtonStyleButton createNamespace(BuildContext context) {
    var list = [FormFieldDef('Namespace Name')];
    return FormUtil.createButton1("Pulsar ${S.of(context).namespace}", list, context, (namespace) async {
      final vm = Provider.of<PulsarTenantViewModel>(context, listen: false);
      vm.createNamespace(namespace);
    });
  }
}
