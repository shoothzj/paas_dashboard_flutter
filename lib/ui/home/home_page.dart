import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/home/home_drawer.dart';
import 'package:paas_dashboard_flutter/ui/pulsar/pulsar_page.dart';

class HomePage extends StatelessWidget {
  HomePage() : super();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Paas Dashboard'),
      ),
      body: ListView(
        children: [
          Center(
              child: Text(
            'Welcome to Dashboard.',
            style: TextStyle(fontSize: 30),
          )),
          Center(
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              padding: const EdgeInsets.all(20),
              children: [
                buildPaasCard(context, "pulsar"),
                buildPaasCard(context, "bookkeeper"),
                buildPaasCard(context, "zookeeper"),
                buildPaasCard(context, "elasticsearch"),
                buildPaasCard(context, "kubernetes"),
                buildPaasCard(context, "kafka"),
                buildPaasCard(context, "flink"),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget buildPaasCard(BuildContext context, String name) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: ElevatedButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/$name');
        },
        child: ListView(
          children: [
            Image.asset('assets/images/icons/$name.png'),
            Center(
              child: Text(name, style: TextStyle(color: Colors.black),),
            )
          ],
        ),
        style: ElevatedButton.styleFrom(
            primary: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
            textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
