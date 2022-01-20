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
import 'package:paas_dashboard_flutter/module/ssh/ssh_step.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';

import 'k8s_instance_view_model.dart';

class K8sInstanceListViewModel extends ChangeNotifier {
  List<K8sInstanceViewModel> instances = <K8sInstanceViewModel>[];

  Future<void> fetchKubernetesInstances() async {
    final results = await Persistent.kubernetesInstances();
    this.instances = results.map((e) => K8sInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createKubernetesSsh(String name, SshStep sshStep) async {
    Persistent.saveKubernetesSsh(name, [sshStep]);
    fetchKubernetesInstances();
  }

  Future<void> deleteKubernetes(int id) async {
    Persistent.deleteKubernetes(id);
    fetchKubernetesInstances();
  }
}
