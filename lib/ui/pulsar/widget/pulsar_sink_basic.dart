import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_basic_view_model.dart';
import 'package:provider/provider.dart';

class PulsarSinkBasicWidget extends StatefulWidget {
  PulsarSinkBasicWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarSinkBasicWidgetState();
  }
}

class PulsarSinkBasicWidgetState extends State<PulsarSinkBasicWidget> {
  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarSinkBasicViewModel>(context, listen: false);
    vm.fetch();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarSinkBasicViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processOpException(vm, context);
    var refreshButton =
        TextButton(onPressed: () {}, child: Text(S.of(context).refresh));
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
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'inputs is ${vm.inputs}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'configs is ${vm.configs}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'archive is ${vm.archive}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
    return body;
  }
}
