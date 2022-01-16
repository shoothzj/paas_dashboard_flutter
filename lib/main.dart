import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/route/route_gen.dart';
import 'package:paas_dashboard_flutter/ui/bk/bk_page.dart';
import 'package:paas_dashboard_flutter/ui/code/code_list_page.dart';
import 'package:paas_dashboard_flutter/ui/general/author_screen.dart';
import 'package:paas_dashboard_flutter/ui/general/settings_screen.dart';
import 'package:paas_dashboard_flutter/ui/home/home_page.dart';
import 'package:paas_dashboard_flutter/ui/kubernetes/k8s_page.dart';
import 'package:paas_dashboard_flutter/ui/mongo/mongo_page.dart';
import 'package:paas_dashboard_flutter/ui/mysql/mysql_page.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_page.dart';
import 'package:paas_dashboard_flutter/ui/redis/redis_page.dart';
import 'package:paas_dashboard_flutter/ui/sql/sql_list_page.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/code/code_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/code/code_view_model.dart';
import 'package:paas_dashboard_flutter/vm/general/settings_view_model.dart';
import 'package:paas_dashboard_flutter/vm/kubernetes/k8s_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_database_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mongo/mongo_instance_view_model.dart';
import 'package:paas_dashboard_flutter/vm/mysql/mysql_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_namespace_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_partitioned_topic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_sink_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_source_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_topic_view_model.dart';
import 'package:paas_dashboard_flutter/vm/redis/redis_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/sql/sql_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/sql/sql_view_model.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paas Dashboard',
      localizationsDelegates: [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: S.delegate.supportedLocales,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      initialRoute: PageRouteConst.Root,
      routes: {
        PageRouteConst.Root: (context) => HomePage(),
        PageRouteConst.Author: (context) => AuthorScreen(),
        PageRouteConst.Bookkeeper: (context) => ChangeNotifierProvider(
              create: (context) => BkInstanceListViewModel(),
              child: BkPage(),
            ),
        PageRouteConst.Code: (context) => ChangeNotifierProvider(
              create: (context) => CodeListViewModel(),
              child: CodeListPage(),
            ),
        PageRouteConst.Kubernetes: (context) => ChangeNotifierProvider(
              create: (context) => K8sInstanceListViewModel(),
              child: K8sPage(),
            ),
        PageRouteConst.Mongo: (context) => ChangeNotifierProvider(
              create: (context) => MongoInstanceListViewModel(),
              child: MongoPage(),
            ),
        PageRouteConst.Mysql: (context) => ChangeNotifierProvider(
              create: (context) => MysqlInstanceListViewModel(),
              child: MysqlPage(),
            ),
        PageRouteConst.Pulsar: (context) => ChangeNotifierProvider(
              create: (context) => PulsarInstanceListViewModel(),
              child: PulsarPage(),
            ),
        PageRouteConst.Redis: (context) => ChangeNotifierProvider(
              create: (context) => RedisInstanceListViewModel(),
              child: RedisPage(),
            ),
        PageRouteConst.Settings: (context) => ChangeNotifierProvider(
              create: (context) => SettingsViewModel(),
              child: SettingsScreen(),
            ),
        PageRouteConst.Sql: (context) => ChangeNotifierProvider(
              create: (context) => SqlListViewModel(),
              child: SqlListPage(),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PageRouteConst.CodeExecute) {
          final args = settings.arguments as CodeViewModel;
          return RouteGen.codeExecute(args);
        }
        if (settings.name == PageRouteConst.MongoInstance) {
          final args = settings.arguments as MongoInstanceViewModel;
          return RouteGen.mongoInstance(args);
        }
        if (settings.name == PageRouteConst.MongoDatabase) {
          final args = settings.arguments as MongoDatabaseViewModel;
          return RouteGen.mongoDatabase(args);
        }
        if (settings.name == PageRouteConst.PulsarInstance) {
          final args = settings.arguments as PulsarInstanceViewModel;
          return RouteGen.pulsarInstance(args);
        }
        if (settings.name == PageRouteConst.PulsarTenant) {
          final args = settings.arguments as PulsarTenantViewModel;
          return RouteGen.pulsarTenant(args);
        }
        if (settings.name == PageRouteConst.PulsarNamespace) {
          final args = settings.arguments as PulsarNamespaceViewModel;
          return RouteGen.pulsarNamespace(args);
        }
        if (settings.name == PageRouteConst.PulsarPartitionedTopic) {
          final args = settings.arguments as PulsarPartitionedTopicViewModel;
          return RouteGen.pulsarPartitionedTopic(args);
        }
        if (settings.name == PageRouteConst.PulsarTopic) {
          final args = settings.arguments as PulsarTopicViewModel;
          return RouteGen.pulsarTopic(args);
        }
        if (settings.name == PageRouteConst.PulsarSource) {
          final args = settings.arguments as PulsarSourceViewModel;
          return RouteGen.pulsarSource(args);
        }
        if (settings.name == PageRouteConst.PulsarSink) {
          final args = settings.arguments as PulsarSinkViewModel;
          return RouteGen.pulsarSink(args);
        }
        if (settings.name == PageRouteConst.SqlExecute) {
          final args = settings.arguments as SqlViewModel;
          return RouteGen.sqlExecute(args);
        }
        throw UnimplementedError();
      },
    );
  }
}
