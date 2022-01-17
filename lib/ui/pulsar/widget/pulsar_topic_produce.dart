import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_produce_view_model.dart';
import 'package:provider/provider.dart';

class PulsarTopicProduceWidget extends StatefulWidget {
  PulsarTopicProduceWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarTopicProduceWidgetState();
  }
}

class PulsarTopicProduceWidgetState extends State<PulsarTopicProduceWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarTopicProduceViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var produceMsgButton = createInstanceButton(context);
    var body = ListView(
      children: [
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [produceMsgButton],
          ),
        ),
      ],
    );
    return Scaffold(body: body);
  }

  ButtonStyleButton createInstanceButton(BuildContext context) {
    final vm = Provider.of<PulsarTopicProduceViewModel>(context, listen: false);
    var list = [
      FormFieldDef('message key'),
      FormFieldDef('message value'),
    ];
    return FormUtil.createButton2NoText("Send Message To Pulsar", list, context, (key, value) {
      vm.sendMsg(key, value);
    });
  }
}
