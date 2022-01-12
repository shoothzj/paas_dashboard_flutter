import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/persistent.dart';

import 'code_view_model.dart';

class CodeListViewModel extends ChangeNotifier {
  List<CodeViewModel> instances = <CodeViewModel>[];

  Future<void> fetchCodeList() async {
    final results = await Persistent.codeList();
    this.instances = results.map((e) => CodeViewModel(e)).toList();
    notifyListeners();
  }

  Future<void> createCode(String name, String code) async {
    Persistent.saveCode(name, code);
    fetchCodeList();
  }

  Future<void> deleteCode(int id) async {
    Persistent.deleteCode(id);
    fetchCodeList();
  }
}
