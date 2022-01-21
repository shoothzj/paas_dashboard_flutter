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
import 'package:paas_dashboard_flutter/ui/mysql/widget/mysql_database.dart';
import 'package:paas_dashboard_flutter/ui/mysql/widget/mysql_user.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_database_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_instance_view_model.dart';
import 'package:provider/provider.dart';

/// MySQL instance window
class MysqlInstanceScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MysqlInstanceState();
  }
}

class _MysqlInstanceState extends State<MysqlInstanceScreen> {
  _MysqlInstanceState();

  @override
  Widget build(BuildContext context) {
    MysqlInstanceViewModel vm = Provider.of<MysqlInstanceViewModel>(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mysql ${vm.name} db Dashboard'),
          bottom: TabBar(tabs: [
            Tab(
              text: S.of(context).database,
            ),
            Tab(text: S.of(context).detail),
          ]),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => MysqlDatabaseViewModel(vm.mysqlInstancePo.deepCopy()),
              child: MysqlDatabaseWidget(),
            ).build(context),
            ChangeNotifierProvider(
              create: (context) => vm.deepCopy(),
              child: MysqlUserWidget(),
            ).build(context)
          ],
        ),
      ),
    );
  }
}
