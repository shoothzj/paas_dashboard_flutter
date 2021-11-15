import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_produce_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicProduceWidget extends StatefulWidget {
  PulsarPartitionedTopicProduceWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicProduceWidgetState();
  }
}

class PulsarPartitionedTopicProduceWidgetState
    extends State<PulsarPartitionedTopicProduceWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarPartitionedTopicProduceViewModel>(context,
        listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicProduceViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var refreshButton =
        TextButton(onPressed: () {}, child: Text(S.of(context).refresh));
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
      ],
    );
    return body;
  }
}
