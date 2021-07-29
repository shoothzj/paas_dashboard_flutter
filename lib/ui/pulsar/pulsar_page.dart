import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_converter.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/persistent/pulsar_instance_po.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';

class PulsarPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _PulsarPageState();
  }
}

class _PulsarPageState extends State<PulsarPage> {
  late Future<List<PulsarInstancePo>> _func;

  @override
  void initState() {
    _func = Persistent.pulsarInstances();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var instancesFuture = FutureBuilder(
        future: _func,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<PulsarInstancePo> data =
                snapshot.data as List<PulsarInstancePo>;
            return SingleChildScrollView(
              child: DataTable(
                showCheckboxColumn: false,
                columns: [
                  DataColumn(label: Text('Id')),
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Port')),
                  DataColumn(label: Text('Delete instance')),
                ],
                rows: data
                    .map((itemRow) => DataRow(
                            onSelectChanged: (bool? selected) {
                              Navigator.pushNamed(context, '/pulsar/instance',
                                  arguments:
                                      PulsarConverter.instance2Module(itemRow));
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
          } else if (snapshot.hasError) {
            return AlertUtil.create(snapshot.error, context);
          }
          // By default, show a loading spinner.
          return SpinnerUtil.create();
        });
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(onPressed: (){setState(() {
      _func = Persistent.pulsarInstances();
    });}, child: Text('Refresh'));
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
    var list = [
      FormFieldDef('Instance Name'),
      FormFieldDef('Instance Host'),
      FormFieldDef('Instance Port')
    ];
    return FormUtil.createButton3("Pulsar Instance", list, context,
        (name, host, port) {
      Persistent.savePulsar(name, host, int.parse(port));
    });
  }
}
