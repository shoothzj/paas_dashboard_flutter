import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/code/widget/code_execute_widget.dart';
import 'package:paas_dashboard_flutter/vm/code/code_view_model.dart';
import 'package:provider/provider.dart';

class CodeExecuteScreen extends StatefulWidget {
  CodeExecuteScreen();

  @override
  State<StatefulWidget> createState() {
    return new CodeExecuteScreenState();
  }
}

class CodeExecuteScreenState extends State<CodeExecuteScreen> {
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
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Code Execute'),
        ),
        body: ChangeNotifierProvider(
          create: (context) => vm.deepCopy(),
          child: CodeExecuteWidget(),
        ).build(context),
      ),
    );
  }
}
