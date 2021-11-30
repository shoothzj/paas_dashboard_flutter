import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSinkListWidget extends StatefulWidget {
  PulsarSinkListWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarSinkListWidgetState();
  }
}

class PulsarSinkListWidgetState extends State<PulsarSinkListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarSinkListViewModel>(context, listen: false);
    vm.fetchSinks();
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
    final vm = Provider.of<PulsarSinkListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(
                  context, PageRouteConst.PulsarPartitionedTopic,
                  arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.sinkName),
              ),
              DataCellUtil.newDellDataCell(() {
                vm.deleteSink(item.sinkName);
              }),
            ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Sink")),
            DataColumn(label: Text(S.of(context).delete)),
          ],
          source: vm),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchSinks();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton],
          ),
        ),
        SearchableTitle("sink list", "search by sink name",
            searchTextController),
        topicsTable
      ],
    );
    return body;
  }
}
