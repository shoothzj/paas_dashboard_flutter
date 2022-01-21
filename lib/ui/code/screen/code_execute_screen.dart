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
import 'package:paas_dashboard_flutter/ui/code/widget/code_execute_widget.dart';
import 'package:paas_dashboard_flutter/vm/code/code_view_model.dart';
import 'package:provider/provider.dart';

class CodeExecuteScreen extends StatefulWidget {
  CodeExecuteScreen();

  @override
  State<StatefulWidget> createState() {
    return new CodeExecuteScreenState();
  }
}

class CodeExecuteScreenState extends State<CodeExecuteScreen> {
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
    final vm = Provider.of<CodeViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Code Execute'),
        ),
        body: ChangeNotifierProvider(
          create: (context) => vm.deepCopy(),
          child: CodeExecuteWidget(),
        ).build(context),
      ),
    );
  }
}
