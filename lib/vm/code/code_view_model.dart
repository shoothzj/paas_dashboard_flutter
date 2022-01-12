import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/persistent/po/code_instance_po.dart';

class CodeViewModel extends ChangeNotifier {
  final CodePo codePo;

  CodeViewModel(this.codePo);

  CodeViewModel deepCopy() {
    return new CodeViewModel(codePo.deepCopy());
  }

  int get id {
    return this.codePo.id;
  }

  String get name {
    return this.codePo.name;
  }

  String get code {
    return this.codePo.code;
  }
}
