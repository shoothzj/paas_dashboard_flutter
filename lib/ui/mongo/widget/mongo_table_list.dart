import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_table_list_view_model.dart';
import 'package:provider/provider.dart';

class MongoTableListWidget extends StatefulWidget {
  MongoTableListWidget();

  @override
  State<StatefulWidget> createState() {
    return new MongoTableListWidgetState();
  }
}

class MongoTableListWidgetState extends State<MongoTableListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MongoTableListViewModel>(context, listen: false);
    vm.fetchTables();
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
    final vm = Provider.of<MongoTableListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(onSelectChanged: (bool? selected) {}, cells: [
          DataCell(
            Text(item.tableName),
          ),
        ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Table")),
          ],
          source: vm),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchTables();
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
        SearchableTitle("table list", "search by table name", searchTextController),
        topicsTable
      ],
    );
    return body;
  }
}
