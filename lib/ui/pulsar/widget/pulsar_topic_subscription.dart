import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/component/clear_backlog_button.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_subscription_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicSubscriptionWidget extends StatefulWidget {
  PulsarTopicSubscriptionWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTopicSubscriptionWidgetState();
  }
}

class PulsarTopicSubscriptionWidgetState
    extends State<PulsarTopicSubscriptionWidget> {
  @override
  void initState() {
    super.initState();
    final vm =
        Provider.of<PulsarTopicSubscriptionViewModel>(context, listen: false);
    vm.fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicSubscriptionViewModel>(context);
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
            DataColumn(label: Text(S.of(context).subscriptionName)),
            DataColumn(label: Text('MsgBacklog')),
            DataColumn(label: Text('MsgRateOut')),
            DataColumn(label: Text(S.of(context).clearBacklog)),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.subscriptionName),
                    ),
                    DataCell(
                      Text(data.backlog.toString()),
                    ),
                    DataCell(
                      Text(data.rateOut.toString()),
                    ),
                    DataCell(ClearBacklogButton(() {
                      vm.clearBacklog(data.subscriptionName);
                    })),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchSubscriptions();
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
          S.of(context).subscriptionList,
          style: TextStyle(fontSize: 22),
        ),
        subscriptionFuture
      ],
    );
    return body;
  }
}
