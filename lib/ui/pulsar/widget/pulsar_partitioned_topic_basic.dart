import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_basic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarPartitionedTopicBasicWidget extends StatefulWidget {
  PulsarPartitionedTopicBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicBasicWidgetState();
  }
}

class PulsarPartitionedTopicBasicWidgetState
    extends State<PulsarPartitionedTopicBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarPartitionedTopicBasicViewModel>(context,
        listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarPartitionedTopicBasicViewModel>(context);
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
      ],
    );
    return body;
  }
}
