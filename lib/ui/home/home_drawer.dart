import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/route/page_route_const.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Dashboard',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage(
                        'assets/images/background/joy_valley_slide.png'))),
          ),
          ListTile(
            title: Text('About author'),
            onTap: () => {Navigator.of(context).pop()},
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () =>
                {Navigator.of(context).pushNamed(PageRouteConst.Settings)},
          ),
        ],
      ),
    );
  }
}
