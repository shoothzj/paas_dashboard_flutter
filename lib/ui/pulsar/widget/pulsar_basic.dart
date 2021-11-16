import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_cluster_view_model.dart';
import 'package:provider/provider.dart';

class PulsarBasicWidget extends StatefulWidget {
  PulsarBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarBasicScreenState();
  }
}

class PulsarBasicScreenState extends State<PulsarBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarClusterViewModel>(context, listen: false);
    vm.fetchPulsarCluster();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarClusterViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    var topicsFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).brokersName)),
            DataColumn(label: Text(S.of(context).versionName)),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.instance),
                    ),
                    DataCell(
                      Text(data.version),
                    ),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchPulsarCluster();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton],
          ),
        ),
        Text(
          'Pulsar Cluster',
          style: TextStyle(fontSize: 22),
        ),
        topicsFuture
      ],
    );

    return body;
  }
}
