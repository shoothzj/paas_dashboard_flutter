import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/ui/page_route_const.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_namespace_api.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_const.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';

class PulsarTenantScreen extends StatefulWidget {
  final TenantPageContext tenantPageContext;

  PulsarTenantScreen(this.tenantPageContext);

  @override
  State<StatefulWidget> createState() {
    return new PulsarTenantScreenState(this.tenantPageContext);
  }
}

class PulsarTenantScreenState extends State<PulsarTenantScreen> {
  final TenantPageContext tenantPageContext;

  late Future<List<NamespaceResp>> _func;

  PulsarTenantScreenState(this.tenantPageContext);

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formButton = createNamespace(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            loadData();
          });
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
        Text('Namespaces', style: TextStyle(fontSize: 22),),
        FutureBuilder(
            future: _func,
            builder: (ctx, snapshot) {
              if (snapshot.hasData) {
                List<NamespaceResp> data = snapshot.data as List<NamespaceResp>;
                return SingleChildScrollView(
                  child: DataTable(
                      showCheckboxColumn: false,
                      columns: [
                        DataColumn(label: Text('Namespace Name')),
                        DataColumn(label: Text('Delete namespace')),
                      ],
                      rows: data
                          .map((data) => DataRow(
                                  onSelectChanged: (bool? selected) {
                                    Navigator.pushNamed(
                                        context, PageRouteConst.RouteNamespace,
                                        arguments: new NamespacePageContext(
                                            tenantPageContext,
                                            new PulsarNamespaceModule(
                                                data.namespaceName)));
                                  },
                                  cells: [
                                    DataCell(
                                      Text(data.namespaceName),
                                    ),
                                    DataCell(TextButton(
                                      child: Text('Delete'),
                                      onPressed: () {
                                        PulsarNamespaceAPi.deleteNamespace(
                                            tenantPageContext.host,
                                            tenantPageContext.port,
                                            tenantPageContext.tenantName,
                                            data.namespaceName);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(PulsarConst.ScreenTitleTenant),
      ),
      body: listView,
    );
  }

  loadData() {
    _func = PulsarNamespaceAPi.getNamespaces(tenantPageContext.host,
        tenantPageContext.port, tenantPageContext.tenantName);
  }

  ButtonStyleButton createNamespace(BuildContext context) {
    var list = [FormFieldDef('Namespace Name')];
    return FormUtil.createButton1("Pulsar Namespace", list, context,
        (namespace) async {
      try {
        await PulsarNamespaceAPi.createNamespace(tenantPageContext.host,
            tenantPageContext.port, tenantPageContext.tenantName, namespace);
        loadData();
      } on Exception catch (e) {
        AlertUtil.exceptionDialog(e, context);
      }
    });
  }
}
