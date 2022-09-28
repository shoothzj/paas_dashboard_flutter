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
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_partitioned_topic.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_cluster_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:provider/provider.dart';

class PulsarBasicWidget extends StatefulWidget {
  const PulsarBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarBasicScreenState();
  }
}

class PulsarBasicScreenState extends State<PulsarBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarClusterViewModel>(context, listen: false);
    vm.fetchPulsarCluster();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarClusterViewModel>(context);
    final instanceVm = Provider.of<PulsarInstanceViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadExceptionPageable(vm, context);
    ExceptionUtil.processOpExceptionPageable(vm, context);
    var topicsFuture = SingleChildScrollView(
      child: DataTable(
          showCheckboxColumn: false,
          columns: [
            DataColumn(label: Text(S.of(context).brokersName)),
            DataColumn(label: Text(S.of(context).versionName)),
          ],
          rows: vm.displayList
              .map((data) => DataRow(cells: [
                    DataCell(
                      Text(data.instance),
                    ),
                    DataCell(
                      Text(data.version),
                    ),
                  ]))
              .toList()),
    );
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchPulsarCluster();
        },
        child: Text(S.of(context).refresh));
    var tenantExportButton = FormUtil.exportButtonAsync(
        'pulsar-${instanceVm.name}-tenant', 'tenant', TenantCsv.fieldList(), () => instanceVm.getAllTenant(), context);
    var tenantImportButton =
        FormUtil.importButton("tenant", TenantCsv.fieldList(), context, (data) => instanceVm.createAllTenant(data));
    var namespaceExportButton = FormUtil.exportButtonAsync('pulsar-${instanceVm.name}-namespace', 'namespace',
        NamespaceCsv.fieldList(), () => instanceVm.getAllNamespace(instanceVm.getAllTenant()), context);
    var namespaceImportButton = FormUtil.importButton(
        "namespace", NamespaceCsv.fieldList(), context, (data) => instanceVm.createAllNamespace(data));
    var topicExportButton = FormUtil.exportButtonAsync(
        'pulsar-${instanceVm.name}-topic',
        'partition-topic',
        PartitionedTopicCsv.fieldList(),
        () => instanceVm.getAllTopic(instanceVm.getAllNamespaceName(instanceVm.getAllTenant())),
        context);
    var topicImportButton = FormUtil.importButton(
        "partition-topic", PartitionedTopicCsv.fieldList(), context, (data) => instanceVm.createAllTopic(data));
    var body = ListView(
      children: <Widget>[
        SizedBox(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              refreshButton,
              tenantExportButton,
              tenantImportButton,
              namespaceExportButton,
              namespaceImportButton,
              topicExportButton,
              topicImportButton,
            ],
          ),
        ),
        const Text(
          'Pulsar Cluster',
          style: TextStyle(fontSize: 22),
        ),
        topicsFuture
      ],
    );

    return body;
  }
}
