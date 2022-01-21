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
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_policies_view_model.dart';
import 'package:provider/provider.dart';

class PulsarNamespacePoliciesWidget extends StatefulWidget {
  PulsarNamespacePoliciesWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarNamespacePoliciesWidgetState();
  }
}

class PulsarNamespacePoliciesWidgetState extends State<PulsarNamespacePoliciesWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarNamespacePoliciesViewModel>(context, listen: false);
    vm.fetchPolicy();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarNamespacePoliciesViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    var autoTopicCreationController = TextEditingController(text: vm.isAllowAutoTopicCreateDisplayStr);
    var messageTTLController = TextEditingController(text: vm.messageTTLDisplayStr);
    var maxProducersPerTopicController = TextEditingController(text: vm.maxProducersPerTopicDisplayStr);
    var maxConsumersPerTopicController = TextEditingController(text: vm.maxConsumersPerTopicDisplayStr);
    var maxConsumerPerSubscriptionController = TextEditingController(text: vm.maxConsumersPerSubscriptionDisplayStr);
    var maxUnAckedPerConsumersController = TextEditingController(text: vm.maxUnackedMessagesPerConsumerDisplayStr);
    var maxUnAckedPerSubscriptionController =
        TextEditingController(text: vm.maxUnackedMessagesPerSubscriptionDisplayStr);
    var maxSubscriptionController = TextEditingController(text: vm.maxSubscriptionsPerTopicDisplayStr);
    var maxTopicsPerNamespacesController = TextEditingController(text: vm.maxTopicsPerNamespaceDisplayStr);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchPolicy();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "autoTopicCreation"),
            controller: autoTopicCreationController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.isAllowAutoTopicCreation = (autoTopicCreationController.value.text == "true" ||
                        autoTopicCreationController.value.text == "TRUE");
                    vm.updateAutoTopicCreate();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "messageTTLSecond"),
            controller: messageTTLController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.messageTTLInSeconds = int.parse(messageTTLController.value.text);
                    vm.setMessageTTLSecond();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxProducersPerTopic"),
            controller: maxProducersPerTopicController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxProducersPerTopic = int.parse(maxProducersPerTopicController.value.text);
                    vm.setMaxProducersPerTopic();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxConsumersPerTopic"),
            controller: maxConsumersPerTopicController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxConsumersPerTopic = int.parse(maxConsumersPerTopicController.value.text);
                    vm.setMaxConsumersPerTopic();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxConsumersPerSubscription"),
            controller: maxConsumerPerSubscriptionController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxConsumersPerSubscription = int.parse(maxConsumerPerSubscriptionController.value.text);
                    vm.setMaxConsumersPerSubscription();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxUnackedMessagesPerConsumer"),
            controller: maxUnAckedPerConsumersController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxUnackedMessagesPerConsumer = int.parse(maxUnAckedPerConsumersController.value.text);
                    vm.setMaxUnackedMessagesPerConsumer();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxUnackedMessagesPerSubscription"),
            controller: maxUnAckedPerSubscriptionController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxUnackedMessagesPerSubscription = int.parse(maxUnAckedPerSubscriptionController.value.text);
                    vm.setMaxUnackedMessagesPerSubscription();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxSubscriptionsPerTopic"),
            controller: maxSubscriptionController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxSubscriptionsPerTopic = int.parse(maxSubscriptionController.value.text);
                    vm.setMaxSubscriptionsPerTopic();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
        Container(
          height: 50,
          child: TextFormField(
            decoration: InputDecoration(labelText: "maxTopicsPerNamespace"),
            controller: maxTopicsPerNamespacesController,
          ),
        ),
        Container(
          height: 20,
          padding: EdgeInsets.only(left: 0),
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              TextButton(
                  onPressed: () {
                    vm.maxTopicsPerNamespace = int.parse(maxTopicsPerNamespacesController.value.text);
                    vm.setMaxTopicsPerNamespace();
                  },
                  style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.only(left: 0)),
                      backgroundColor: MaterialStateProperty.all(Colors.grey),
                      overlayColor: MaterialStateProperty.all(Colors.lightGreen)),
                  child: Text(S.of(context).submit,
                      style: TextStyle(fontSize: 15, color: Colors.white), textAlign: TextAlign.left))
            ],
          ),
        ),
      ],
    );
    return body;
  }
}
