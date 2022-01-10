import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/mongo/widget/mongo_table_list.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_table_list_view_model.dart';
import 'package:provider/provider.dart';

class MongoDatabaseScreen extends StatefulWidget {
  MongoDatabaseScreen();

  @override
  State<StatefulWidget> createState() {
    return new MongoDatabaseScreenState();
  }
}

class MongoDatabaseScreenState extends State<MongoDatabaseScreen> {
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
    final vm = Provider.of<MongoDatabaseViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mongo ${vm.name} -> ${vm.databaseName}'),
          bottom: TabBar(
            tabs: [
              Tab(text: "Tables"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) =>
                  MongoTableListViewModel(vm.mongoInstancePo, vm.databaseResp),
              child: MongoTableListWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
