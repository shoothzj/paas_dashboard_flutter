import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_const.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTenantScreen extends StatefulWidget {
  PulsarTenantScreen();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTenantScreenState();
  }
}

class PulsarTenantScreenState extends State<PulsarTenantScreen> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTenantViewModel>(context, listen: false);
    vm.fetchNamespaces();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTenantViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    if (vm.loadException != null) {
      Exception ex = vm.loadException!;
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        AlertUtil.exceptionDialog(ex, context);
      });
    }
    if (vm.opException != null) {
      Exception ex = vm.opException!;
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        AlertUtil.exceptionDialog(ex, context);
      });
    }
    var formButton = createNamespace(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchNamespaces();
        },
        child: Text('Refresh'));
    var listView = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton],
          ),
        ),
        Text(
          'Namespaces',
          style: TextStyle(fontSize: 22),
        ),
        SingleChildScrollView(
          child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text('Namespace Name')),
                DataColumn(label: Text('Delete namespace')),
              ],
              rows: vm.namespaces
                  .map((data) => DataRow(
                          onSelectChanged: (bool? selected) {
                            Navigator.pushNamed(
                                context, PageRouteConst.PulsarNamespace,
                                arguments: new NamespacePageContext(data,
                                    new PulsarNamespaceModule(data.namespace)));
                          },
                          cells: [
                            DataCell(
                              Text(data.namespace),
                            ),
                            DataCell(TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                vm.deleteNamespace(data.namespace);
                              },
                            )),
                          ]))
                  .toList()),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(PulsarConst.ScreenTitleTenant),
      ),
      body: listView,
    );
  }

  ButtonStyleButton createNamespace(BuildContext context) {
    var list = [FormFieldDef('Namespace Name')];
    return FormUtil.createButton1("Pulsar Namespace", list, context,
        (namespace) async {
      final vm = Provider.of<PulsarTenantViewModel>(context, listen: false);
      vm.createNamespace(namespace);
    });
  }
}
