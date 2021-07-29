import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_tenant_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/ui/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';

class PulsarTenantsWidget extends StatefulWidget {
  final PulsarInstanceContext instanceContext;

  PulsarTenantsWidget(this.instanceContext);

  @override
  State<StatefulWidget> createState() {
    return new PulsarTenantsState(this.instanceContext);
  }
}

class PulsarTenantsState extends State<PulsarTenantsWidget> {
  final PulsarInstanceContext instanceContext;

  late Future<List<TenantResp>> _func;

  PulsarTenantsState(this.instanceContext);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formButton = createTenant(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            loadData();
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
        Text('Tenants', style: TextStyle(fontSize: 22),),
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
                                        context, PageRouteConst.RouteTenant,
                                        arguments: new TenantPageContext(
                                            instanceContext,
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
                                            instanceContext.host,
                                            instanceContext.port,
                                            data.tenantName);
                                        loadData();
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

  loadData() {
    _func =
        PulsarTenantAPi.getTenants(instanceContext.host, instanceContext.port);
  }

  ButtonStyleButton createTenant(BuildContext context) {
    var list = [FormFieldDef('Tenant Name')];
    return FormUtil.createButton1("Pulsar Tenant", list, context,
        (tenantName) async {
      try {
        await PulsarTenantAPi.createTenant(
            instanceContext.host, instanceContext.port, tenantName);
        loadData();
      } on Exception catch (e) {
        AlertUtil.exceptionDialog(e, context);
      }
    });
  }
}
