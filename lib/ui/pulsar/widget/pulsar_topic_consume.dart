import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_consume_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicConsumeWidget extends StatefulWidget {
  PulsarTopicConsumeWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTopicConsumeWidgetState();
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
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var messageId = TextEditingController(text: vm.messageId);
    var messageList = SingleChildScrollView();
    if (vm.messageList.length != 0) {
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
                          decoration: InputDecoration(border: InputBorder.none),
                          readOnly: true,
                        ),
                      ),
                      DataCell(
                        TextField(
                          controller: TextEditingController(text: data.message),
                          maxLines: null,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(border: InputBorder.none),
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
          margin: EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: searchMessageIdController,
            decoration: InputDecoration(
                fillColor: Colors.green,
                labelText: Text(S.of(context).searchByTimestampWithHint).data,
                hintText: Text(S.of(context).searchByTimestampWithHint).data,
                enabledBorder: OutlineInputBorder(
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
          margin: EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: messageId,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(border: InputBorder.none),
            readOnly: true,
          ),
        ),
        Container(
          margin: EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: searchTimestampController,
            decoration: InputDecoration(
                fillColor: Colors.green,
                labelText: Text(S.of(context).searchByMessageIdWithHint).data,
                hintText: Text(S.of(context).searchByMessageIdWithHint).data,
                enabledBorder: OutlineInputBorder(
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
          margin: EdgeInsetsDirectional.only(top: 10),
          child: TextField(
            controller: TextEditingController(text: vm.message),
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(border: InputBorder.none),
            readOnly: true,
          ),
        ),
        messageList
      ],
    );
    return body;
  }
}
