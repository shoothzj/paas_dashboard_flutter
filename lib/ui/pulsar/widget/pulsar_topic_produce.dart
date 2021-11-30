import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_produce_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicProduceWidget extends StatefulWidget {
  PulsarTopicProduceWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTopicProduceWidgetState();
  }
}

class PulsarTopicProduceWidgetState extends State<PulsarTopicProduceWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarTopicProduceViewModel>(context, listen: false);
    vm.fetchProducers();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicProduceViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var subscriptionFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text('ProducerName')),
            DataColumn(label: Text('MsgRateIn')),
            DataColumn(label: Text('MsgThroughputIn')),
            DataColumn(label: Text('ClientVersion')),
            DataColumn(label: Text('AverageMsgSize')),
            DataColumn(label: Text('Address')),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.producerName),
                    ),
                    DataCell(
                      Text(data.rateIn.toString()),
                    ),
                    DataCell(
                      Text(data.throughputIn.toString()),
                    ),
                    DataCell(
                      Text(data.clientVersion.toString()),
                    ),
                    DataCell(
                      Text(data.averageMsgSize.toString()),
                    ),
                    DataCell(
                      Text(data.address.toString()),
                    ),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchProducers();
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
          S.of(context).producerList,
          style: TextStyle(fontSize: 22),
        ),
        subscriptionFuture,
      ],
    );
    return body;
  }
}
