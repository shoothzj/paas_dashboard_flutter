import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_partitioned_topic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:provider/provider.dart';

class RouteGen {
  static Route pulsarInstance(PulsarInstanceViewModel viewModel) {
    // deep copy view model
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel.deepCopy(),
              child: PulsarInstanceScreen(),
            ));
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
