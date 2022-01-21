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
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_view_model.dart';

class BkInstanceListViewModel extends ChangeNotifier {
  List<BkInstanceViewModel> instances = <BkInstanceViewModel>[];

  Future<void> fetchBkInstances() async {
    final results = await Persistent.bookkeeperInstances();
    this.instances = results.map((e) => BkInstanceViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createBk(String name, String host, int port) async {
    Persistent.saveBookkeeper(name, host, port);
    fetchBkInstances();
  }

  Future<void> deleteBk(int id) async {
    Persistent.deleteBookkeeper(id);
    fetchBkInstances();
  }
}
