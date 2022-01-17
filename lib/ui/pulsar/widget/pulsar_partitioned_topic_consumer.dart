import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_consumer_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicConsumerWidget extends StatefulWidget {
  PulsarPartitionedTopicConsumerWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicConsumerWidgetState();
  }
}

class PulsarPartitionedTopicConsumerWidgetState extends State<PulsarPartitionedTopicConsumerWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarPartitionedTopicConsumerViewModel>(context, listen: false);
    vm.fetchConsumers();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicConsumerViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var consumerFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('SubscriptionName')),
            DataColumn(label: Text('ConsumerName')),
            DataColumn(label: Text('MsgRateOut')),
            DataColumn(label: Text('MsgThroughputOut')),
            DataColumn(label: Text('AvailablePermits')),
            DataColumn(label: Text('UnackedMessages')),
            DataColumn(label: Text('LastConsumedTimestamp')),
            DataColumn(label: Text('ClientVersion')),
            DataColumn(label: Text('Address')),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.subscriptionName),
                    ),
                    DataCell(
                      Text(data.consumerName),
                    ),
                    DataCell(
                      Text(data.rateOut.toString()),
                    ),
                    DataCell(
                      Text(data.throughputOut.toString()),
                    ),
                    DataCell(
                      Text(data.availablePermits.toString()),
                    ),
                    DataCell(
                      Text(data.unackedMessages.toString()),
                    ),
                    DataCell(
                      Text(data.lastConsumedTimestamp.toString()),
                    ),
                    DataCell(
                      Text(data.clientVersion.toString()),
                    ),
                    DataCell(
                      Text(data.address.toString()),
                    ),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchConsumers();
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
        Text(
          S.of(context).consumerList,
          style: TextStyle(fontSize: 22),
        ),
        consumerFuture,
      ],
    );
    return body;
  }
}
