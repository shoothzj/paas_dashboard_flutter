import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class MysqlPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MysqlPageState();
  }
}

class _MysqlPageState extends State<MysqlPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MysqlInstanceListViewModel>(context, listen: false)
        .fetchMysqlInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MysqlInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchMysqlInstances();
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
          child: Text('Mysql Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Host')),
              DataColumn(label: Text('Port')),
              DataColumn(label: Text('Username')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(
                              context, PageRouteConst.MysqlInstance,
                              arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.host)),
                          DataCell(Text(itemRow.port.toString())),
                          DataCell(Text(itemRow.username)),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Mysql Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<MysqlInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Host'),
      FormFieldDef('Port'),
      FormFieldDef('Username'),
      FormFieldDef('Password'),
    ];
    return FormUtil.createButton5("Mysql Instance", list, context,
        (name, host, port, username, password) {
      vm.createMysql(name, host, int.parse(port), username, password);
    });
  }
}
