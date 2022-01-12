import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/mongo/mongo_instance.dart';
import 'package:paas_dashboard_flutter/ui/mongo/screen/mongo_database.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_partitioned_topic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_sink.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_source.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/sql/screen/sql_execute_screen.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/sql/sql_view_model.dart';
import 'package:provider/provider.dart';

class RouteGen {
  static Route mongoInstance(MongoInstanceViewModel viewModel) {
    // deep copy view model
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: MongoInstanceScreen(),
            ));
  }

  static Route mongoDatabase(MongoDatabaseViewModel viewModel) {
    // deep copy view model
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: MongoDatabaseScreen(),
            ));
  }

  static Route pulsarInstance(PulsarInstanceViewModel viewModel) {
    // deep copy view model
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarInstanceScreen(),
            ));
  }

  static Route pulsarTenant(PulsarTenantViewModel viewModel) {
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarTenantScreen(),
            ));
  }

  static Route pulsarNamespace(PulsarNamespaceViewModel viewModel) {
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarNamespaceScreen(),
            ));
  }

  static Route pulsarPartitionedTopic(PulsarPartitionedTopicViewModel viewModel) {
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarPartitionedTopic(),
            ));
  }

  static Route pulsarTopic(PulsarTopicViewModel viewModel) {
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarTopic(),
            ));
  }

  static Route pulsarSource(PulsarSourceViewModel viewModel) {
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarSourceScreen(),
            ));
  }

  static Route pulsarSink(PulsarSinkViewModel viewModel) {
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: PulsarSinkScreen(),
            ));
  }

  static Route sqlExecute(SqlViewModel viewModel) {
    // deep copy view model
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: SqlExecuteScreen(),
            ));
  }
}
