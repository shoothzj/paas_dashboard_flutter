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
import 'package:paas_dashboard_flutter/vm/sql/sql_view_model.dart';
import 'package:provider/provider.dart';

class SqlExecuteWidget extends StatefulWidget {
  SqlExecuteWidget();

  @override
  State<StatefulWidget> createState() {
    return new SqlExecuteWidgetState();
  }
}

class SqlExecuteWidgetState extends State<SqlExecuteWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SqlViewModel>(context);
    var body = ListView(
      children: [
        Container(
          height: 50,
          child: Text(vm.sql),
        ),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(S.of(context).submit)),
      ],
    );
    return body;
  }
}
