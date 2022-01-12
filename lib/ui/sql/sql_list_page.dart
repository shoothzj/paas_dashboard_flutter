import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/sql/sql_list_view_model.dart';
import 'package:provider/provider.dart';

class SqlListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _SqlListPageState();
  }
}

class _SqlListPageState extends State<SqlListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<SqlListViewModel>(context, listen: false).fetchSqlList();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<SqlListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchSqlList();
          });
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton],
          ),
        ),
        Center(
          child: Text('Sql List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Sql')),
              DataColumn(label: Text('Delete sql')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.SqlExecute, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.sql)),
                          DataCellUtil.newDellDataCell(() {
                            vm.deleteSql(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Sql Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<SqlListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Sql Name'),
      FormFieldDef('Sql'),
    ];
    return FormUtil.createButton2("Sql", list, context, (name, sql) {
      vm.createSql(name, sql);
    });
  }
}
