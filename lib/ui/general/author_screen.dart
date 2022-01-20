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
import 'package:paas_dashboard_flutter/module/author.dart';

class AuthorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Author> authors = [
      Author('fu_turer', 'Tian Luo', "futurer@outlook.com"),
      Author('goflutterjava', 'KeLe He', "goflutterjava@gmail.com"),
      Author('lovehzj', 'TingTing Wang', "1922919664@qq.com"),
      Author('shoothzj', 'ZhangJian He', 'shoothzj@gmail.com'),
      Author('zxJin-x', 'ZhiXin Jin', 'jinzhixin096@gmail.com'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).aboutAuthor),
      ),
      body: Center(
        child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).name)),
            DataColumn(label: Text(S.of(context).email)),
          ],
          rows: authors
              .map((itemRow) => DataRow(onSelectChanged: (bool? selected) {}, cells: [
                    DataCell(Text(itemRow.name)),
                    DataCell(Text(itemRow.email)),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
