import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_detail_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicDetailWidget extends StatefulWidget {
  PulsarPartitionedTopicDetailWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicDetailWidgetState();
  }
}

class PulsarPartitionedTopicDetailWidgetState
    extends State<PulsarPartitionedTopicDetailWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarPartitionedTopicDetailViewModel>(context,
        listen: false);
    vm.fetchPartitions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicDetailViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var partitionsFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('TopicName')),
            DataColumn(label: Text('BacklogSize')),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.topicName),
                    ),
                    DataCell(
                      Text(data.backlogSize.toString()),
                    ),
                  ]))
              .toList()),
    );
    var refreshButton =
        TextButton(onPressed: () {
          vm.fetchPartitions();
        }, child: Text(S.of(context).refresh));
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
        Text(
          S.of(context).consumerList,
          style: TextStyle(fontSize: 22),
        ),
        partitionsFuture,
      ],
    );
    return body;
  }
}
