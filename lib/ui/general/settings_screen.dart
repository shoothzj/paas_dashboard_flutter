import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/generated/l10n.dart';
import 'package:paas_dashboard_flutter/vm/general/settings_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen();

  @override
  State<StatefulWidget> createState() {
    return new SettingsScreenState();
  }
}

class SettingsScreenState extends State<SettingsScreen> {
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
    final vm = Provider.of<SettingsViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).settings),
      ),
      body: ExpansionTile(
        title: Text(S.of(context).languageSettings),
        leading: Icon(Icons.language),
        initiallyExpanded: false,
        children: [
          RadioListTile(title: Text('English'), value: 'en', groupValue: vm.language, onChanged: _changed),
          RadioListTile(title: Text('汉语'), value: 'zh', groupValue: vm.language, onChanged: _changed),
        ],
      ),
    );
  }

  void _changed(value) {
    if (value != null) {
      log('change language to $value');
      final vm = Provider.of<SettingsViewModel>(context, listen: false);
      if (value != null) {
        vm.setLan(value);
      }
    }
  }
}
