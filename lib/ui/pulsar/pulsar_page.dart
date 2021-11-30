import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PulsarPageState();
  }
}

class _PulsarPageState extends State<PulsarPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<PulsarInstanceListViewModel>(context, listen: false)
        .fetchPulsarInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarInstanceListViewModel>(context);
    var tableView = SingleChildScrollView(
      child: DataTable(
        showCheckboxColumn: false,
        columns: [
          DataColumn(label: Text('Id')),
          DataColumn(label: Text('Name')),
          DataColumn(label: Text('Host')),
          DataColumn(label: Text('Port')),
          DataColumn(label: Text('FunctionHost')),
          DataColumn(label: Text('FunctionPort')),
          DataColumn(label: Text('Delete instance')),
        ],
        rows: vm.instances
            .map((itemRow) => DataRow(
                    onSelectChanged: (bool? selected) {
                      Navigator.pushNamed(
                          context, PageRouteConst.PulsarInstance,
                          arguments: itemRow.deepCopy());
                    },
                    cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCell(Text(itemRow.host)),
                      DataCell(Text(itemRow.port.toString())),
                      DataCell(Text(itemRow.functionHost)),
                      DataCell(Text(itemRow.functionPort.toString())),
                      DataCellUtil.newDellDataCell(() {
                        vm.deletePulsar(itemRow.id);
                      }),
                    ]))
            .toList(),
      ),
    );
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchPulsarInstances();
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
          child: Text('Pulsar Instance List'),
        ),
        tableView
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Pulsar Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<PulsarInstanceListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Host'),
      FormFieldDef('Port'),
      FormFieldDef('Function Host'),
      FormFieldDef('Function Port'),
    ];
    return FormUtil.createButton5("Pulsar Instance", list, context,
        (name, host, port, functionHost, functionPort) {
      vm.createPulsar(name, host, int.parse(port), functionHost, int.parse(functionPort));
    });
  }
}
