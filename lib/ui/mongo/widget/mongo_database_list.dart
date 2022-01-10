import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_list_view_model.dart';
import 'package:provider/provider.dart';

class MongoDatabaseListWidget extends StatefulWidget {
  MongoDatabaseListWidget();

  @override
  State<StatefulWidget> createState() {
    return new MongoDatabaseListWidgetState();
  }
}

class MongoDatabaseListWidgetState extends State<MongoDatabaseListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<MongoDatabaseListViewModel>(context, listen: false);
    vm.fetchDatabases();
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
    final vm = Provider.of<MongoDatabaseListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.MongoDatabase, arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.databaseName),
              ),
            ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text("Database")),
          ],
          source: vm),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchDatabases();
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
        SearchableTitle("database list", "search by database name", searchTextController),
        topicsTable
      ],
    );
    return body;
  }
}
