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
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_consume_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicConsumeWidget extends StatefulWidget {
  const PulsarTopicConsumeWidget();

  @override
  State<StatefulWidget> createState() {
    return PulsarTopicConsumeWidgetState();
  }
}

class PulsarTopicConsumeWidgetState extends State<PulsarTopicConsumeWidget> {
  final searchTimestampController = TextEditingController();
  final searchMessageIdController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchTimestampController.addListener(() {});
    searchMessageIdController.addListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicConsumeViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var messageId = TextEditingController(text: vm.messageId);
    var messageList = const SingleChildScrollView();
    if (vm.messageList.isNotEmpty) {
      messageList = SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: DataTable(
            showCheckboxColumn: false,
            columns: [
              DataColumn(label: Text(S.of(context).entryId)),
              DataColumn(label: Text(S.of(context).messageList)),
            ],
            rows: vm.messageList
                .map((data) => DataRow(cells: [
                      DataCell(
                        TextField(
                          controller: TextEditingController(text: data.entryId),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                      DataCell(
                        TextField(
                          controller: TextEditingController(text: data.message),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                    ]))
                .toList()),
      );
    }

    var body = ListView(
      children: <Widget>[
        Container(
            margin: const EdgeInsetsDirectional.only(top: 10),
            child: TextButton(
              onPressed: () {
                DatePicker.showDateTimePicker(context, showTitleActions: true, onChanged: (date) {
                  print("change $date");
                }, onConfirm: (date) {
                  searchMessageIdController.text = date.millisecondsSinceEpoch.toString();
                }, currentTime: DateTime.now(), locale: LocaleType.zh);
              },
              child: Text(S.of(context).timePick),
            )),
        Container(
          margin: const EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: searchMessageIdController,
            decoration: InputDecoration(
                fillColor: Colors.green,
                labelText: Text(S.of(context).searchByTimestampWithHint).data,
                hintText: Text(S.of(context).searchByTimestampWithHint).data,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey,
                  width: 5.0,
                ))),
            cursorColor: Colors.orange,
            onSubmitted: (text) {
              vm.fetchMessageId(text);
            },
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: messageId,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(border: InputBorder.none),
            readOnly: true,
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: searchTimestampController,
            decoration: InputDecoration(
                fillColor: Colors.green,
                labelText: Text(S.of(context).searchByMessageIdWithHint).data,
                hintText: Text(S.of(context).searchByMessageIdWithHint).data,
                enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blueGrey,
                  width: 5.0,
                ))),
            cursorColor: Colors.orange,
            onSubmitted: (text) {
              vm.fetchConsumerMessage(text);
            },
          ),
        ),
        Container(
          margin: const EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: TextEditingController(text: vm.message),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: const InputDecoration(border: InputBorder.none),
            readOnly: true,
          ),
        ),
        messageList
      ],
    );
    return body;
  }
}
