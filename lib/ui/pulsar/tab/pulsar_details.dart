import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
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
  late Future<List<TenantResp>> _func;

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarInstanceViewModel>(context, listen: false);
    loadData(vm.host, vm.port);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarInstanceViewModel>(context);
    var formButton = createTenant(context, vm.host, vm.port);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            loadData(vm.host, vm.port);
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
        FutureBuilder(
            future: _func,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                List<TenantResp> data = snapshot.data as List<TenantResp>;
                return SingleChildScrollView(
                  child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text('TenantName')),
                        DataColumn(label: Text('Delete tenant')),
                      ],
                      rows: data
                          .map((data) => DataRow(
                                  onSelectChanged: (bool? selected) {
                                    Navigator.pushNamed(
                                        context, PageRouteConst.PulsarTenant,
                                        arguments: new TenantPageContext(
                                            vm.host,
                                            vm.port,
                                            new PulsarTenantModule(
                                                data.tenantName)));
                                  },
                                  cells: [
                                    DataCell(
                                      Text(data.tenantName),
                                    ),
                                    DataCell(TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        PulsarTenantAPi.deleteTenant(
                                            vm.host, vm.port, data.tenantName);
                                        loadData(vm.host, vm.port);
                                      },
                                    )),
                                  ]))
                          .toList()),
                );
              } else if (snapshot.hasError) {
                return AlertUtil.create(snapshot.error, context);
              }
              // By default, show a loading spinner.
              return SpinnerUtil.create();
            })
      ],
    );
    return body;
  }

  loadData(String host, int port) {
    _func = PulsarTenantAPi.getTenants(host, port);
  }

  ButtonStyleButton createTenant(BuildContext context, String host, int port) {
    var list = [FormFieldDef('Tenant Name')];
    return FormUtil.createButton1("Pulsar Tenant", list, context,
        (tenantName) async {
      try {
        await PulsarTenantAPi.createTenant(host, port, tenantName);
        loadData(host, port);
      } on Exception catch (e) {
        AlertUtil.exceptionDialog(e, context);
      }
    });
  }
}
