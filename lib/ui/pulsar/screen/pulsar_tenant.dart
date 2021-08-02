import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
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
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTenantViewModel>(context, listen: false);
    vm.fetchNamespaces();
    searchTextController.addListener(() {
      vm.filter(searchTextController.text);
    });
  }

  @override
  void dispose() {
    searchTextController.dispose();
    super.dispose();
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
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarNamespace,
                  arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.namespace),
              ),
              DataCell(TextButton(
                child: Text(S.of(context).delete),
                onPressed: () {
                  vm.deleteNamespace(item.namespace);
                },
              )),
            ]));
    var formButton = createNamespace(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchNamespaces();
        },
        child: Text(S.of(context).refresh));
    var searchBox = Container(
      width: 300,
      child: TextField(
        controller: searchTextController,
      ),
    );
    var listView = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [formButton, refreshButton, searchBox],
          ),
        ),
        Text(
          'Namespaces',
          style: TextStyle(fontSize: 22),
        ),
        SingleChildScrollView(
          child: PaginatedDataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text('Namespace Name')),
                DataColumn(label: Text('Delete namespace')),
              ],
              source: vm),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulsar Tenant ${vm.tenant}'),
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
