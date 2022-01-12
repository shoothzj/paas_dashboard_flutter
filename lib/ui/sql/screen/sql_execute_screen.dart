import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/sql/widget/sql_execute_widget.dart';
import 'package:paas_dashboard_flutter/vm/sql/sql_view_model.dart';
import 'package:provider/provider.dart';

class SqlExecuteScreen extends StatefulWidget {
  SqlExecuteScreen();

  @override
  State<StatefulWidget> createState() {
    return new SqlExecuteScreenState();
  }
}

class SqlExecuteScreenState extends State<SqlExecuteScreen> {
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
    final vm = Provider.of<SqlViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sql Execute'),
        ),
        body: ChangeNotifierProvider(
          create: (context) => vm.deepCopy(),
          child: SqlExecuteWidget(),
        ).build(context),
      ),
    );
  }
}
