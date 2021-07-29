
import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';

class PulsarPartitionedTopicScreen extends StatefulWidget {
  final TopicPageContext topicPageContext;

  PulsarPartitionedTopicScreen(this.topicPageContext);

  @override
  State<StatefulWidget> createState() {
    return new PulsarPartitionedTopicScreenState(this.topicPageContext);
  }
}

class PulsarPartitionedTopicScreenState extends State<PulsarPartitionedTopicScreen> {
  final TopicPageContext topicPageContext;

  PulsarPartitionedTopicScreenState(this.topicPageContext);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pulsar Partitioned Topic'),
      ),
      body: Text('Topic'),
    );
  }
}
