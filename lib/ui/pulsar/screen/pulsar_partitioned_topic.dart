import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';

class PulsarPartitionedTopicScreen extends StatefulWidget {
  final TopicPageContext topicPageContext;

  PulsarPartitionedTopicScreen(this.topicPageContext);

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicScreenState(this.topicPageContext);
  }
}

class PulsarPartitionedTopicScreenState
    extends State<PulsarPartitionedTopicScreen> {
  final TopicPageContext topicPageContext;

  PulsarPartitionedTopicScreenState(this.topicPageContext);

  late Future<List<SubscriptionResp>> _func;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var topicsFuture = FutureBuilder(
        future: _func,
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            List<SubscriptionResp> data =
                snapshot.data as List<SubscriptionResp>;
            return SingleChildScrollView(
              child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(label: Text('Subscription Name')),
                    DataColumn(label: Text('Delete Subscription')),
                    DataColumn(label: Text('Stats')),
                  ],
                  rows: data
                      .map((data) => DataRow(cells: [
                            DataCell(
                              Text(data.subscriptionName),
                            ),
                            DataCell(TextButton(
                              child: Text('clear-backlog'),
                              onPressed: () {
                                PulsarTopicAPi.deleteSubscription(
                                    topicPageContext.host,
                                    topicPageContext.port,
                                    topicPageContext.tenantName,
                                    topicPageContext.namespaceName,
                                    topicPageContext.topicName,
                                    data.subscriptionName);
                              },
                            )),
                            DataCell(TextButton(
                              child: Text('backlog'),
                              onPressed: () {},
                            )),
                          ]))
                      .toList()),
            );
          } else if (snapshot.hasError) {
            return AlertUtil.create(snapshot.error, context);
          }
          // By default, show a loading spinner.
          return SpinnerUtil.create();
        });
    var refreshButton = TextButton(
        onPressed: () {
          setState(() {
            loadData();
          });
        },
        child: Text('Refresh'));
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
          'Partitioned Topics',
          style: TextStyle(fontSize: 22),
        ),
        topicsFuture
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Pulsar Partitioned Topic'),
      ),
      body: body,
    );
  }

  void loadData() {
    _func = PulsarTopicAPi.getSubscription(
        topicPageContext.host,
        topicPageContext.port,
        topicPageContext.tenantName,
        topicPageContext.namespaceName,
        topicPageContext.topicName);
  }
}
