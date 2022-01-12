import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/vm/kubernetes/k8s_instance_list_view_model.dart';
import 'package:provider/provider.dart';

class K8sPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _K8sPageState();
  }
}

class _K8sPageState extends State<K8sPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<K8sInstanceListViewModel>(context, listen: false).fetchKubernetesInstances();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<K8sInstanceListViewModel>(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchKubernetesInstances();
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
            children: [refreshButton],
          ),
        ),
        Center(
          child: Text('Kubernetes Instance List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Delete instance')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(onSelectChanged: (bool? selected) {}, cells: [
                      DataCell(Text(itemRow.id.toString())),
                      DataCell(Text(itemRow.name)),
                      DataCellUtil.newDellDataCell(() {
                        vm.deleteKubernetes(itemRow.id);
                      }),
                    ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Kubernetes Dashboard'),
        ),
        body: body);
  }
}
