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
import 'package:paas_dashboard_flutter/vm/mongo/mongo_table_view_model.dart';
import 'package:provider/provider.dart';

/// Mongo table data list windows
class MongoTableDataWidget extends StatefulWidget {
  MongoTableDataWidget();

  @override
  State<StatefulWidget> createState() {
    return new _MongoTableDataState();
  }
}

class _MongoTableDataState extends State<MongoTableDataWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MongoTableViewModel>(context, listen: false);
    vm.fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MongoTableViewModel>(context);
    vm.setDataConverter(vm.getConvert);
    var dbsFuture = SingleChildScrollView(
      child: PaginatedDataTable(
        showCheckboxColumn: false,
        columns: vm.getColumns().map((e) => DataColumn(label: SelectableText(e))).toList(),
        source: vm,
      ),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchData();
        },
        child: Text(S.of(context).refresh));

    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton],
          ),
        ),
        dbsFuture
      ],
    );

    return DefaultTabController(
        length: 1,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Mongo ${vm.name} -> ${vm.databaseName} DB -> ${vm.tableName} table'),
            bottom: TabBar(
              tabs: [Tab(text: S.of(context).data)],
            ),
          ),
          body: TabBarView(
            children: [body],
          ),
        ));
  }
}
