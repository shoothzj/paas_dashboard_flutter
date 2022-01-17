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
            DataColumn(label: Text("github id")),
            DataColumn(label: Text(S.of(context).name)),
            DataColumn(label: Text(S.of(context).email)),
          ],
          rows: authors
              .map((itemRow) => DataRow(onSelectChanged: (bool? selected) {}, cells: [
                    DataCell(Text(itemRow.githubId)),
                    DataCell(Text(itemRow.name)),
                    DataCell(Text(itemRow.email)),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
