import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class MongoPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _MongoPageState();
  }
}

class _MongoPageState extends State<MongoPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<MongoInstanceListViewModel>(context, listen: false).fetchMongoInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MongoInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchMongoInstances();
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
          child: Text('Mongo Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Addr')),
              DataColumn(label: Text('Username')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.MongoInstance, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.addr)),
                          DataCell(Text(itemRow.username)),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Mongo Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<MongoInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Addr'),
      FormFieldDef('Username'),
      FormFieldDef('Password'),
    ];
    return FormUtil.createButton4("Mongo Instance", list, context, (name, addr, username, password) {
      vm.createMongo(name, addr, username, password);
    });
  }
}
