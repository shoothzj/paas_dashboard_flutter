import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/ui/util/exception_util.dart';
import 'package:paas_dashboard_flutter/ui/util/form_util.dart';
import 'package:paas_dashboard_flutter/ui/util/spinner_util.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_backlog_quota_view_model.dart';
import 'package:provider/provider.dart';

class PulsarNamespaceBacklogQuotaWidget extends StatefulWidget {
  PulsarNamespaceBacklogQuotaWidget();

  @override
  State<StatefulWidget> createState() {
    return new PulsarNamespaceBacklogQuotaWidgetState();
  }
}

class PulsarNamespaceBacklogQuotaWidgetState extends State<PulsarNamespaceBacklogQuotaWidget> {

  @override
  void initState() {
    super.initState();
    final vm = Provider.of<PulsarNamespaceBacklogQuotaViewModel>(context, listen: false);
    vm.fetchBacklogQuota();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<PulsarNamespaceBacklogQuotaViewModel>(context);
    if (vm.loading) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        SpinnerUtil.create();
      });
    }
    ExceptionUtil.processLoadException(vm, context);
    ExceptionUtil.processLoadException(vm, context);
    var formButton = modifyBacklogQuotaButton(context);
    var refreshButton = TextButton(
        onPressed: () {
          vm.fetchBacklogQuota();
        },
        child: Text(S.of(context).refresh));
    var body = ListView(
      children: <Widget>[
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [refreshButton, formButton],
          ),
        ),
        Container(
          height: 50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            children: [
              Text(
                'LimitSize is ${vm.limitSize}',
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
                'LimitTime is ${vm.limitTime}',
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
                'Policy is ${vm.retentionPolicy}',
                style: new TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
      ],
    );
    return body;
  }

  ButtonStyleButton modifyBacklogQuotaButton(BuildContext context) {
    var list = [FormFieldDef('New Limit Size'), FormFieldDef('New Limit Time'), FormFieldDef('New Policy')];
    return FormUtil.updateButton3("New Backlog Quota", list, context,
            (limitSize, limitTime, policy) async {
          final vm = Provider.of<PulsarNamespaceBacklogQuotaViewModel>(context,
              listen: false);
          vm.updateBacklogQuota(limitSize, limitTime, policy);
        });
  }
}
