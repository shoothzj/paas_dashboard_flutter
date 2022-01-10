import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/mongo/widget/mongo_database_list.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_view_model.dart';
import 'package:provider/provider.dart';

class MongoInstanceScreen extends StatefulWidget {
  MongoInstanceScreen();

  @override
  State<StatefulWidget> createState() {
    return new _MongoInstanceState();
  }
}

class _MongoInstanceState extends State<MongoInstanceScreen> {
  _MongoInstanceState();

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<MongoInstanceViewModel>(context);
    return DefaultTabController(
      length: 1,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Mongo ${vm.name} Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(
                text: "Databases",
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            ChangeNotifierProvider(
              create: (context) => MongoDatabaseListViewModel(vm.mongoInstancePo.deepCopy()),
              child: MongoDatabaseListWidget(),
            ).build(context),
          ],
        ),
      ),
    );
  }
}
