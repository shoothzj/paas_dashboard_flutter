import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/redis/redis_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class RedisPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _RedisPageState();
  }
}

class _RedisPageState extends State<RedisPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<RedisInstanceListViewModel>(context, listen: false).fetchRedisInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<RedisInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchRedisInstances();
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
          child: Text('Redis Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Addr')),
              DataColumn(label: Text('Username')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.RedisInstance, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.addr)),
                          DataCell(Text(itemRow.username)),
                          DataCellUtil.newDelDataCell(() {
                            vm.deleteRedis(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Redis Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<RedisInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Addr'),
      FormFieldDef('Username'),
      FormFieldDef('Password'),
    ];
    return FormUtil.createButton4("Redis Instance", list, context, (name, addr, username, password) {
      vm.createRedis(name, addr, username, password);
    });
  }
}
