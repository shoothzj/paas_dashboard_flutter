import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
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
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarInstanceViewModel>(context, listen: false);
    vm.fetchTenants();
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
    final vm = Provider.of<PulsarInstanceViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarTenant,
                  arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.tenant),
              ),
              DataCellUtil.newDellDataCell(() {
                vm.deleteTenants(item.tenant);
              }),
            ]));
    var formButton = createTenant(context, vm.host, vm.port);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchTenants();
        },
        child: Text(S.of(context).refresh));
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
        SearchableTitle(S.of(context).tenants, S.of(context).searchByTenant,
            searchTextController),
        SingleChildScrollView(
          child: PaginatedDataTable(
              showCheckboxColumn: false,
              columns: [
                DataColumn(label: Text(S.of(context).tenantName)),
                DataColumn(label: Text(S.of(context).deleteTenant)),
              ],
              source: vm),
        )
      ],
    );
    return body;
  }

  ButtonStyleButton createTenant(BuildContext context, String host, int port) {
    final vm = Provider.of<PulsarInstanceViewModel>(context, listen: false);
    var list = [FormFieldDef(S.of(context).tenantName)];
    return FormUtil.createButton1("Pulsar Tenant", list, context,
        (tenant) async {
      vm.createTenant(tenant);
    });
  }
}
