import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/api/pulsar/pulsar_topic_api.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';

class PulsarNamespaceScreen extends StatefulWidget {
  final NamespacePageContext namespacePageContext;

  PulsarNamespaceScreen(this.namespacePageContext);

  @override
  State<StatefulWidget> createState() {
    return new PulsarNamespaceScreenState(this.namespacePageContext);
  }
}

class PulsarNamespaceScreenState extends State<PulsarNamespaceScreen> {
  final NamespacePageContext namespacePageContext;

  late Future<List<TopicResp>> _func;

  PulsarNamespaceScreenState(this.namespacePageContext);

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
            List<TopicResp> data = snapshot.data as List<TopicResp>;
            return SingleChildScrollView(
              child: DataTable(
                  showCheckboxColumn: false,
                  columns: [
                    DataColumn(label: Text('Topic Name')),
                    DataColumn(label: Text('Delete Topic')),
                    DataColumn(label: Text('Stats')),
                  ],
                  rows: data
                      .map((data) => DataRow(
                              onSelectChanged: (bool? selected) {
                                Navigator.pushNamed(
                                    context, PageRouteConst.PulsarTopic,
                                    arguments: new TopicPageContext(
                                        namespacePageContext,
                                        new PulsarTopicModule(data.topicName)));
                              },
                              cells: [
                                DataCell(
                                  Text(data.topicName),
                                ),
                                DataCell(TextButton(
                                  child: Text('Delete'),
                                  onPressed: () {
                                    PulsarTopicAPi.deletePartitionTopic(
                                        namespacePageContext.host,
                                        namespacePageContext.port,
                                        namespacePageContext.tenantName,
                                        namespacePageContext.namespaceName,
                                        data.topicName);
                                    loadData();
                                  },
                                )),
                                DataCell(TextButton(
                                  child: Text('Stats'),
                                  onPressed: () {
                                    PulsarTopicAPi.deletePartitionTopic(
                                        namespacePageContext.host,
                                        namespacePageContext.port,
                                        namespacePageContext.tenantName,
                                        namespacePageContext.namespaceName,
                                        data.topicName);
                                  },
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
    var formButton = createPartitionTopicButton(context);
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
            children: [formButton, refreshButton],
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
        title: Text('Pulsar Namespace'),
      ),
      body: body,
    );
  }

  loadData() {
    _func = PulsarTopicAPi.getTopics(
        namespacePageContext.host,
        namespacePageContext.port,
        namespacePageContext.tenantName,
        namespacePageContext.namespaceName);
  }

  ButtonStyleButton createPartitionTopicButton(BuildContext context) {
    var list = [FormFieldDef('Topic Name'), FormFieldDef('Partition Number')];
    return FormUtil.createButton2("Partitioned Topic", list, context,
        (topic, partition) async {
      try {
        await PulsarTopicAPi.createPartitionTopic(
            namespacePageContext.host,
            namespacePageContext.port,
            namespacePageContext.tenantName,
            namespacePageContext.namespaceName,
            topic,
            int.parse(partition));
        loadData();
      } on Exception catch (e) {
        AlertUtil.exceptionDialog(e, context);
      }
    });
  }
}
