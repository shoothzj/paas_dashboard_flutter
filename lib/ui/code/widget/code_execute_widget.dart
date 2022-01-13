import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/vm/code/code_view_model.dart';
import 'package:provider/provider.dart';

class CodeExecuteWidget extends StatefulWidget {
  CodeExecuteWidget();

  @override
  State<StatefulWidget> createState() {
    return new CodeExecuteWidgetState();
  }
}

class CodeExecuteWidgetState extends State<CodeExecuteWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<CodeViewModel>(context);
    var body = ListView(
      children: [
        Container(
          height: 50,
          child: Text(vm.code),
        ),
        TextButton(
            onPressed: () {
              setState(() {});
            },
            child: Text(S.of(context).submit)),
      ],
    );
    return body;
  }
}
