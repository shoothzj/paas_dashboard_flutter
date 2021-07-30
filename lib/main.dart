import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/ui/bk/bk_page.dart';
import 'package:paas_dashboard_flutter/ui/home/home_page.dart';
import 'package:paas_dashboard_flutter/ui/page_route_const.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_instance.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_page.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_partitioned_topic.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/screen/pulsar_tenant.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_list_view_model.dart';
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
      initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/bookkeeper': (context) => ChangeNotifierProvider(
              create: (context) => BkInstanceListViewModel(),
              child: BkPage(),
            ),
        '/pulsar': (context) => ChangeNotifierProvider(
              create: (context) => PulsarInstanceListViewModel(),
              child: PulsarPage(),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PageRouteConst.RouteInstance) {
          final args = settings.arguments as PulsarInstanceContext;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PulsarInstanceScreen(args);
            },
          );
        }
        if (settings.name == PageRouteConst.RouteTenant) {
          final args = settings.arguments as TenantPageContext;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PulsarTenantScreen(args);
            },
          );
        }
        if (settings.name == PageRouteConst.RouteNamespace) {
          final args = settings.arguments as NamespacePageContext;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PulsarNamespaceScreen(args);
            },
          );
        }
        if (settings.name == PageRouteConst.RouteTopic) {
          final args = settings.arguments as TopicPageContext;

          // Then, extract the required data from
          // the arguments and pass the data to the
          // correct screen.
          return MaterialPageRoute(
            builder: (context) {
              return PulsarPartitionedTopicScreen(args);
            },
          );
        }
      },
    );
  }
}
