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
import 'package:paas_dashboard_flutter/ui/mongo/widget/mongo_database_list.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_view_model.dart';
import 'package:provider/provider.dart';

class MongoInstanceScreen extends StatefulWidget {
  MongoInstanceScreen();

  @override
  State<StatefulWidget> createState() {
    return new _MongoInstanceState();
  }
}

class _MongoInstanceState extends State<MongoInstanceScreen> {
  _MongoInstanceState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MongoInstanceViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mongo ${vm.name} Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Databases",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => MongoDatabaseListViewModel(vm.mongoInstancePo.deepCopy()),
              child: MongoDatabaseListWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
