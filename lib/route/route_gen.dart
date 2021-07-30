import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_partitioned_topic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_tenant.dart';

class RouteGen {
  static Route pulsarInstance(PulsarInstanceContext args) {
    return MaterialPageRoute(
      builder: (context) {
        return PulsarInstanceScreen(args);
      },
    );
  }

  static Route pulsarTenant(TenantPageContext args) {
    return MaterialPageRoute(
      builder: (context) {
        return PulsarTenantScreen(args);
      },
    );
  }

  static Route pulsarNamespace(NamespacePageContext args) {
    return MaterialPageRoute(
      builder: (context) {
        return PulsarNamespaceScreen(args);
      },
    );
  }

  static Route pulsarPartitionedTopic(TopicPageContext args) {
    return MaterialPageRoute(
      builder: (context) {
        return PulsarPartitionedTopicScreen(args);
      },
    );
  }
}
