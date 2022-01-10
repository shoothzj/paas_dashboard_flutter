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

class PulsarNamespacePoliciesWidgetState
    extends State<PulsarNamespacePoliciesWidget> {
  @override
  void initState() {
    super.initState();
    final vm =
        Provider.of<PulsarNamespacePoliciesViewModel>(context, listen: false);
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
      ],
    );
    return body;
  }
}
