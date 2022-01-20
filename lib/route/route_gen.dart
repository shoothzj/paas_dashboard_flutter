//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/code/screen/code_execute_screen.dart';
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
import 'package:paas_dashboard_flutter/vm/code/code_view_model.dart';
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
  static Route codeExecute(CodeViewModel viewModel) {
    // deep copy view model
    return MaterialPageRoute(
        builder: (context) => ChangeNotifierProvider(
              create: (context) => viewModel,
              child: CodeExecuteScreen(),
            ));
  }

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
