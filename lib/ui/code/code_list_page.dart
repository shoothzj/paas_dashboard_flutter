import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/vm/code/code_list_view_model.dart';
import 'package:provider/provider.dart';

class CodeListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new _CodeListPageState();
  }
}

class _CodeListPageState extends State<CodeListPage> {
  @override
  void initState() {
    super.initState();
    Provider.of<CodeListViewModel>(context, listen: false).fetchCodeList();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CodeListViewModel>(context);
    var formButton = createInstanceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            vm.fetchCodeList();
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
            children: [formButton, refreshButton],
          ),
        ),
        Center(
          child: Text('Code List'),
        ),
        SingleChildScrollView(
          child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text('Id')),
              DataColumn(label: Text('Name')),
              DataColumn(label: Text('Code')),
              DataColumn(label: Text('Delete code')),
            ],
            rows: vm.instances
                .map((itemRow) => DataRow(
                        onSelectChanged: (bool? selected) {
                          Navigator.pushNamed(context, PageRouteConst.CodeExecute, arguments: itemRow.deepCopy());
                        },
                        cells: [
                          DataCell(Text(itemRow.id.toString())),
                          DataCell(Text(itemRow.name)),
                          DataCell(Text(itemRow.code)),
                          DataCellUtil.newDellDataCell(() {
                            vm.deleteCode(itemRow.id);
                          }),
                        ]))
                .toList(),
          ),
        ),
      ],
    );
    return Scaffold(
        appBar: AppBar(
          title: Text('Code Dashboard'),
        ),
        body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<CodeListViewModel>(context, listen: false);
    var list = [
      FormFieldDef('Code Name'),
      FormFieldDef('Code'),
    ];
    return FormUtil.createButton2("Code", list, context, (name, code) {
      vm.createCode(name, code);
    });
  }
}
