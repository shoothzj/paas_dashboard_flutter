import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/component/searchable_title.dart';
import 'package:paas_dashboard_flutter/ui/util/data_cell_util.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_list_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicListWidget extends StatefulWidget {
  PulsarTopicListWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTopicListWidgetState();
  }
}

class PulsarTopicListWidgetState extends State<PulsarTopicListWidget> {
  final searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTopicListViewModel>(context, listen: false);
    vm.fetchTopics();
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
    final vm = Provider.of<PulsarTopicListViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    vm.setDataConverter((item) => DataRow(
            onSelectChanged: (bool? selected) {
              Navigator.pushNamed(context, PageRouteConst.PulsarTopic,
                  arguments: item.deepCopy());
            },
            cells: [
              DataCell(
                Text(item.topic),
              ),
              DataCellUtil.newDellDataCell(() {
                vm.deleteTopic(item.topic);
              }),
            ]));
    var topicsTable = SingleChildScrollView(
      child: PaginatedDataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).topicName)),
            DataColumn(label: Text(S.of(context).deleteTopic)),
          ],
          source: vm),
    );
    var formButton = createPartitionTopicButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchTopics();
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
        SearchableTitle(S.of(context).topics, S.of(context).searchByTopic,
            searchTextController),
        topicsTable
      ],
    );
    return body;
  }

  ButtonStyleButton createPartitionTopicButton(BuildContext context) {
    var list = [FormFieldDef('Topic Name')];
    return FormUtil.createButton1("Topic", list, context, (topic) async {
      final vm = Provider.of<PulsarTopicListViewModel>(context, listen: false);
      vm.createTopic(topic);
    });
  }
}
