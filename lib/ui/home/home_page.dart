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
                Container(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PulsarPage()));
                      },
                      child: ListView(
                        children: [
                          Image.asset('assets/images/icons/pulsar.png'),
                          Center(
                            child: Text('Pulsar'),
                          )
                        ],
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: Colors.brown,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold)),
                    ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text('BookKeeper'),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  child: Text('ZooKeeper'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
