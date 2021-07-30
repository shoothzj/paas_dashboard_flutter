import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_converter.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
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
    var instancesFuture = SingleChildScrollView(
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
            .map((itemRow) => DataRow(
                    onSelectChanged: (bool? selected) {
                      Navigator.pushNamed(context, '/pulsar/instance',
                          arguments: PulsarConverter.instance2Module(itemRow));
                    },
                    cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCell(Text(itemRow.host)),
                      DataCell(Text(itemRow.port.toString())),
                      DataCell(TextButton(
                        child: Text('Delete'),
                        onPressed: () {
                          Persistent.deletePulsar(itemRow.id);
                        },
                      )),
                    ]))
            .toList(),
      ),
    );
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchPulsarInstances();
          });
        },
        child: Text('Refresh'));
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
        instancesFuture
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
      FormFieldDef('Instance Host'),
      FormFieldDef('Instance Port')
    ];
    return FormUtil.createButton3("Pulsar Instance", list, context,
        (name, host, port) {
      vm.createPulsar(name, host, int.parse(port));
    });
  }
}
