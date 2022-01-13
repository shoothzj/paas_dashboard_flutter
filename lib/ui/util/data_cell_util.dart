import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/component/delete_button.dart';
import 'package:paas_dashboard_flutter/ui/component/force_delete_button.dart';

class DataCellUtil {
  static DataCell newDelDataCell(VoidCallback voidCallback) {
    return DataCell(DeleteButton(voidCallback));
  }

  static DataCell newForceDelDataCell(Function(bool) callback) {
    return DataCell(ForceDeleteButton(callback));
  }
}
