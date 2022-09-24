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
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/vm/redis/redis_instance_view_model.dart';
import 'package:provider/provider.dart';

class RedisInstanceWidget extends StatefulWidget {
  const RedisInstanceWidget();

  @override
  State<StatefulWidget> createState() {
    return _RedisInstanceWidgetState();
  }
}

class _RedisInstanceWidgetState extends State<RedisInstanceWidget> {
  _RedisInstanceWidgetState();

  DropdownButton? opButton;
  OP opButtonValue = OP.KEYS;
  TextButton? executeButton;
  Row? inputRow;
  Map<int, String> inputValues = {0: ""};

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RedisInstanceViewModel>(context);
    ExceptionUtil.processOpException(vm, context);
    var dbsFuture = SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columns: [
          DataColumn(
              label: SelectableText(
            S.of(context).result,
            style: const TextStyle(color: Colors.red, fontSize: 20),
          ))
        ],
        rows: [
          DataRow(cells: [DataCell(SelectableText(vm.executeResult))])
        ],
      ),
    );

    opButton = DropdownButton(
      items: getOpMenu(),
      underline: Container(),
      onChanged: (value) {
        setState(() {
          opButtonValue = value;
          if (value == OP.HSET) {
            inputValues = {0: "", 1: "", 2: ""};
          } else if (value == OP.SET || value == OP.HGET || value == OP.HDEL) {
            inputValues = {0: "", 1: ""};
          } else {
            inputValues = {0: ""};
          }
        });
      },
      value: opButtonValue,
      isExpanded: true,
    );

    inputRow = Row(
      children: createInput(inputValues.length),
    );

    executeButton = TextButton(
        onPressed: () {
          if (opButtonValue == OP.DELETE || opButtonValue == OP.HDEL) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text(
                      S.of(context).confirmDeleteQuestion,
                      textAlign: TextAlign.center,
                    ),
                    actions: [
                      TextButton(
                        child: Text(S.of(context).cancel),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: Text(S.of(context).confirm),
                        onPressed: () {
                          vm.execute(opButtonValue, List.from(inputValues.values));
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                });
          } else {
            vm.execute(opButtonValue, List.from(inputValues.values));
          }
        },
        child: Text(S.of(context).execute));

    var row1 = Row(
      children: <Widget>[
        Expanded(flex: 1, child: opButton!),
        Expanded(flex: 3, child: inputRow!),
        Expanded(flex: 1, child: executeButton!)
      ],
    );

    Expanded row2 = Expanded(child: dbsFuture);

    var body = ListView(
      shrinkWrap: true,
      children: <Widget>[
        ListView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          children: [row1, row2],
        ),
      ],
    );

    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Redis ${vm.name} Dashboard'),
          bottom: const TabBar(
            tabs: [
              Tab(
                text: "Redis",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [body],
        ),
      ),
    );
  }

  List<DropdownMenuItem<OP>> getOpMenu() {
    List<DropdownMenuItem<OP>> rs = [];
    rs.add(const DropdownMenuItem(value: OP.KEYS, child: Text("KEYS")));
    rs.add(const DropdownMenuItem(value: OP.DELETE, child: Text("DELETE")));
    rs.add(const DropdownMenuItem(value: OP.GET, child: Text("GET")));
    rs.add(const DropdownMenuItem(value: OP.SET, child: Text("SET")));
    rs.add(const DropdownMenuItem(value: OP.HSET, child: Text("HSET")));
    rs.add(const DropdownMenuItem(value: OP.HGET, child: Text("HGET")));
    rs.add(const DropdownMenuItem(value: OP.HGETALL, child: Text("HGETALL")));
    rs.add(const DropdownMenuItem(value: OP.HDEL, child: Text("HDEL")));
    return rs;
  }

  List<Expanded> createInput(int length) {
    List<Expanded> rs = [];
    for (int i = 0; i < length; i++) {
      rs.add(Expanded(
          child: TextField(
        decoration: InputDecoration(labelText: "param${i + 1}"),
        controller: TextEditingController(text: inputValues[i]),
        onChanged: (text) {
          inputValues[i] = text;
        },
      )));
    }
    return rs;
  }
}

enum OP { KEYS, DELETE, GET, SET, HSET, HGET, HDEL, HGETALL }
