import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_namespace.dart';
import 'package:paas_dashboard_flutter/module/pulsar/pulsar_topic.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';
import 'package:paas_dashboard_flutter/route/route_gen.dart';
import 'package:paas_dashboard_flutter/ui/bk/bk_page.dart';
import 'package:paas_dashboard_flutter/ui/home/home_page.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_page.dart';
import 'package:paas_dashboard_flutter/vm/bk/bk_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_list_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_instance_view_model.dart';
import 'package:paas_dashboard_flutter/vm/pulsar/pulsar_tenant_view_model.dart';
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
      initialRoute: PageRouteConst.Root,
      routes: {
        PageRouteConst.Root: (context) => HomePage(),
        PageRouteConst.Bookkeeper: (context) => ChangeNotifierProvider(
              create: (context) => BkInstanceListViewModel(),
              child: BkPage(),
            ),
        PageRouteConst.Pulsar: (context) => ChangeNotifierProvider(
              create: (context) => PulsarInstanceListViewModel(),
              child: PulsarPage(),
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == PageRouteConst.PulsarInstance) {
          final args = settings.arguments as PulsarInstanceViewModel;
          return RouteGen.pulsarInstance(args);
        }
        if (settings.name == PageRouteConst.PulsarTenant) {
          final args = settings.arguments as PulsarTenantViewModel;
          return RouteGen.pulsarTenant(args);
        }
        if (settings.name == PageRouteConst.PulsarNamespace) {
          final args = settings.arguments as NamespacePageContext;
          return RouteGen.pulsarNamespace(args);
        }
        if (settings.name == PageRouteConst.PulsarTopic) {
          final args = settings.arguments as TopicPageContext;
          return RouteGen.pulsarPartitionedTopic(args);
        }
      },
    );
  }
}
