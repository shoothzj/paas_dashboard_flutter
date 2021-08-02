import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class BkPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _BkPageState();
  }
}

class _BkPageState extends State<BkPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<BkInstanceListViewModel>(context, listen: false)
        .fetchBkInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<BkInstanceListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchBkInstances();
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
          child: Text('Bookkeeper Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Address')),
              DataColumn(label: Text('Port')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) =>
                    DataRow(onSelectChanged: (bool? selected) {}, cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCell(Text(itemRow.host)),
                      DataCell(Text(itemRow.port.toString())),
                      DataCell(TextButton(
                        child: Text(S.of(context).delete),
                        onPressed: () {
                          vm.deleteBk(itemRow.id);
                        },
                      )),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Bookkeeper Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<BkInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Instance Host'),
      FormFieldDef('Instance Port')
    ];
    return FormUtil.createButton3("Bookkeeper Instance", list, context,
        (name, host, port) {
      vm.createBk(name, host, int.parse(port));
    });
  }
}
