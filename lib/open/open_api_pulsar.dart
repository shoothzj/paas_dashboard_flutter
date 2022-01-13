import 'package:paas_dashboard_flutter/api/pulsar/pulsar_partitioned_topic_api.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';

class OpenApiPulsar {
  Future<int> partitionTopicCount(String name, String tenant, String namespace) async {
    var pulsarInstance = await Persistent.pulsarInstance(name);
    if (pulsarInstance == null) {
      throw ArgumentError("pulsar instance not exist");
    }
    var list = await PulsarPartitionedTopicApi.getTopics(pulsarInstance.host, pulsarInstance.port, tenant, namespace);
    return list.length;
  }
}
