import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSourceListWidget extends StatefulWidget {
  PulsarSourceListWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarSourceListWidgetState();
  }
}

class PulsarSourceListWidgetState extends State<PulsarSourceListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarSourceListViewModel>(context, listen: false);
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
    final vm = Provider.of<PulsarSourceListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarSource, arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.sourceName),
              ),
              DataCellUtil.newDelDataCell(() {
                vm.deleteSource(item.sourceName);
              }),
            ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Source")),
            DataColumn(label: Text(S.of(context).delete)),
          ],
          source: vm),
    );
    var formButton = createSourceButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchSources();
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
        SearchableTitle("source list", "search by source name", searchTextController),
        topicsTable
      ],
    );
    return body;
  }

  ButtonStyleButton createSourceButton(BuildContext context) {
    var list = [
      FormFieldDef('Source Name'),
      FormFieldDef('Output Topic'),
      FormFieldDef('Source type'),
      FormFieldDef('Config')
    ];
    return FormUtil.createButton4("Source", list, context, (sourceName, outputTopic, sourceType, config) async {
      final vm = Provider.of<PulsarSourceListViewModel>(context, listen: false);
      vm.createSource(sourceName, outputTopic, sourceType, config);
      final scaffold = ScaffoldMessenger.of(context);
      scaffold.showSnackBar(
        SnackBar(
          content: const Text('Dart 目前不支持复杂ContentType请求，Curl命令已复制到剪切版'),
        ),
      );
    });
  }
}
