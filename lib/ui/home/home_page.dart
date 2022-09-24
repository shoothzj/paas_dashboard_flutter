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
import 'package:paas_dashboard_flutter/ui/home/home_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: const Text('Paas Dashboard'),
      ),
      body: ListView(
        children: [
          const Center(
              child: Text(
            'Welcome to Dashboard.',
            style: TextStyle(fontSize: 30),
          )),
          Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              children: [
                buildPaasCard(context, "pulsar"),
                buildPaasCard(context, "bookkeeper"),
                buildPaasCard(context, "mongo"),
                buildPaasCard(context, "mysql"),
                buildPaasCard(context, "kubernetes"),
                buildPaasCard(context, "redis"),
                buildPaasCard(context, "kafka"),
                buildPaasCard(context, "flink"),
                buildPaasCard(context, "zookeeper"),
                buildPaasCard(context, "elasticsearch"),
                buildPaasCard(context, "grafana"),
                buildPaasCard(context, "influxdb"),
                buildPaasCard(context, "rocketmq"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPaasCard(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/$name');
        },
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
        child: ListView(
          children: [
            Image.asset('assets/images/icons/$name.png'),
            Center(
              child: Text(
                name,
                style: const TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
