import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/module/author.dart';

class AuthorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List<Author> authors = [
      Author('fu_turer', "futurer@outlook.com"),
      Author('goflutterjava', "goflutterjava@gmail.com"),
      Author('lovehzj', "1922919664@qq.com"),
      Author('shoothzj', 'shoothzj@gmail.com')
    ];
    List<String> name = ['fu_turer', 'shoothzj'];

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
              .map((itemRow) =>
                  DataRow(onSelectChanged: (bool? selected) {}, cells: [
                    DataCell(Text(itemRow.name)),
                    DataCell(Text(itemRow.email)),
                  ]))
              .toList(),
        ),
      ),
    );
  }
}
