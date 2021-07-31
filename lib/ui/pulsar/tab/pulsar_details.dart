import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTenantsWidget extends StatefulWidget {
  PulsarTenantsWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTenantsState();
  }
}

class PulsarTenantsState extends State<PulsarTenantsWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarInstanceViewModel>(context, listen: false);
    vm.fetchTenants();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarInstanceViewModel>(context);
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
    var formButton = createTenant(context, vm.host, vm.port);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchTenants();
          });
        },
        child: Text('Refresh'));
    var body = ListView(
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
          'Tenants',
          style: TextStyle(fontSize: 22),
        ),
        SingleChildScrollView(
          child: DataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text('TenantName')),
                DataColumn(label: Text('Delete tenant')),
              ],
              rows: vm.tenants
                  .map((data) => DataRow(
                          onSelectChanged: (bool? selected) {
                            Navigator.pushNamed(
                                context, PageRouteConst.PulsarTenant,
                                arguments: data.deepCopy());
                          },
                          cells: [
                            DataCell(
                              Text(data.tenantName),
                            ),
                            DataCell(TextButton(
                              child: Text('Delete'),
                              onPressed: () {
                                vm.deleteTenants(data.tenantName);
                              },
                            )),
                          ]))
                  .toList()),
        )
      ],
    );
    return body;
  }

  ButtonStyleButton createTenant(BuildContext context, String host, int port) {
    final vm = Provider.of<PulsarInstanceViewModel>(context, listen: false);
    var list = [FormFieldDef('Tenant Name')];
    return FormUtil.createButton1("Pulsar Tenant", list, context,
        (tenantName) async {
      vm.createTenant(tenantName);
    });
  }
}
