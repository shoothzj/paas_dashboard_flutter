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

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';

class PulsarForm extends StatefulWidget {
  final Function(PulsarFormDto) callback;
  final PulsarFormDto? formDto;

  const PulsarForm(this.callback, this.formDto);

  @override
  State<StatefulWidget> createState() {
    return __PulsarFormState(callback, formDto);
  }
}

class __PulsarFormState extends State<PulsarForm> {
  Function(PulsarFormDto) callback;
  PulsarFormDto? formDto;
  bool certDisplay = true; //true: don't display
  bool create = true;

  __PulsarFormState(this.callback, this.formDto);

  @override
  void initState() {
    super.initState();
    create = formDto == null;
  }

  @override
  Widget build(BuildContext context) {
    if (!create) {
      return IconButton(
        onPressed: () {
          pulsarFormDialog();
        },
        icon: const Icon(Icons.edit),
      );
    } else {
      return TextButton(
          onPressed: () {
            pulsarFormDialog();
          },
          child: const Text('Create Pulsar Instance'));
    }
  }

  pulsarFormDialog() {
    formDto ??= PulsarFormDto();
    certDisplay = !(formDto!.enableTls || formDto!.functionEnableTls);
    var formFieldDefList = [
      'Instance Name',
      'Host',
      'Port',
      'Function Host',
      'Function Port',
    ];
    Map<String, String> formFieldDefValues = {
      "Instance Name": formDto!.name,
      "Host": formDto!.host,
      "Port": formDto!.port.toString(),
      "Function Host": formDto!.functionHost,
      "Function Port": formDto!.functionPort.toString(),
    };
    var editControllerList = formFieldDefList.map((e) => TextEditingController(text: formFieldDefValues[e])).toList();
    List<TextFormField> formFieldsList = List.generate(
        formFieldDefList.length,
        (index) => TextFormField(
              decoration: InputDecoration(labelText: formFieldDefList[index]),
              controller: editControllerList[index],
            ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, void Function(void Function()) setState) {
            List<Widget> children = List.from(formFieldsList);
            Switch tlsSwitch = Switch(
                value: formDto!.enableTls,
                onChanged: (value) {
                  setState(() {
                    formDto!.enableTls = value;
                    certDisplay = !(formDto!.enableTls || formDto!.functionEnableTls);
                  });
                });
            Row tlsRow = Row(
              children: [
                const Text(
                  "Enable Tls: ",
                  style: TextStyle(color: Colors.blue),
                ),
                tlsSwitch
              ],
            );
            Switch functionTlsSwitch = Switch(
                value: formDto!.functionEnableTls,
                onChanged: (value) {
                  setState(() {
                    formDto!.functionEnableTls = value;
                    certDisplay = !(formDto!.enableTls || formDto!.functionEnableTls);
                  });
                });
            Row functionTlsRow = Row(
              children: [
                const Text(
                  "Function Enable Tls: ",
                  style: TextStyle(color: Colors.blue),
                ),
                functionTlsSwitch
              ],
            );

            TextEditingController caFieldController = TextEditingController(text: formDto!.caFile);
            TextFormField caField = TextFormField(
              decoration: const InputDecoration(labelText: "CA File"),
              controller: caFieldController,
            );
            TextButton caPickerButton = TextButton(
              onPressed: () async {
                FilePickerResult? caPicker = await FilePicker.platform
                    .pickFiles(type: FileType.custom, allowedExtensions: ['pem', 'crt'], allowMultiple: false);
                if (caPicker != null) {
                  setState(() {
                    formDto!.caFile = caPicker.paths[0]!;
                  });
                }
              },
              child: Text(S.of(context).import),
            );
            Row caRow = Row(
              children: [Expanded(child: caField), caPickerButton],
            );
            Offstage caStage = Offstage(
              offstage: certDisplay,
              child: caRow,
            );

            TextEditingController clientCertFieldController = TextEditingController(text: formDto!.clientCertFile);
            TextFormField clientCertField = TextFormField(
              decoration: const InputDecoration(labelText: "Client Cert File"),
              controller: clientCertFieldController,
            );
            TextButton clientCertPickerButton = TextButton(
              onPressed: () async {
                FilePickerResult? caPicker = await FilePicker.platform
                    .pickFiles(type: FileType.custom, allowedExtensions: ['pem', 'crt'], allowMultiple: false);
                if (caPicker != null) {
                  setState(() {
                    formDto!.clientCertFile = caPicker.paths[0]!;
                  });
                }
              },
              child: Text(S.of(context).import),
            );
            Row clientCertRow = Row(
              children: [Expanded(child: clientCertField), clientCertPickerButton],
            );
            Offstage clientCertStage = Offstage(
              offstage: certDisplay,
              child: clientCertRow,
            );

            TextEditingController clientKeyFieldController = TextEditingController(text: formDto!.clientKeyFile);
            TextFormField clientKeyField = TextFormField(
              decoration: const InputDecoration(labelText: "Client Key File"),
              controller: clientKeyFieldController,
            );
            TextButton clientKeyPickerButton = TextButton(
              onPressed: () async {
                FilePickerResult? clientKeyPicker = await FilePicker.platform
                    .pickFiles(type: FileType.custom, allowedExtensions: ['pem', 'crt'], allowMultiple: false);
                if (clientKeyPicker != null) {
                  setState(() {
                    formDto!.clientKeyFile = clientKeyPicker.paths[0]!;
                  });
                }
              },
              child: Text(S.of(context).import),
            );
            Row clientKeyRow = Row(
              children: [Expanded(child: clientKeyField), clientKeyPickerButton],
            );
            Offstage clientKeyStage = Offstage(
              offstage: certDisplay,
              child: clientKeyRow,
            );

            TextEditingController clientKeyPasswordController = TextEditingController(text: formDto!.clientKeyPassword);
            TextFormField clientKeyPasswordField = TextFormField(
              decoration: const InputDecoration(labelText: "Client Key Password"),
              controller: clientKeyPasswordController,
            );
            Offstage clientKeyPasswordStage = Offstage(
              offstage: certDisplay,
              child: clientKeyPasswordField,
            );

            children.add(tlsRow);
            children.add(functionTlsRow);
            children.add(caStage);
            children.add(clientCertStage);
            children.add(clientKeyStage);
            children.add(clientKeyPasswordStage);

            return AlertDialog(
              scrollable: true,
              title: const Text("Create Pulsar Instance Form"),
              content: Form(child: Column(children: children)),
              actions: [
                ElevatedButton(
                  child: const Text(FormUtil.CREATE),
                  onPressed: () {
                    List<String> list = editControllerList.map((e) => e.value.text.trim()).toList();
                    formDto!.name = list[0];
                    formDto!.host = list[1];
                    formDto!.port = int.parse(list[2]);
                    formDto!.functionHost = list[3];
                    formDto!.functionPort = int.parse(list[4]);
                    formDto!.clientKeyPassword = clientKeyPasswordController.value.text;
                    callback(formDto!);
                    Navigator.of(context).pop();
                  },
                ),
                ElevatedButton(
                  child: const Text(FormUtil.CANCEL),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            );
          },
        );
      },
    );
  }
}
