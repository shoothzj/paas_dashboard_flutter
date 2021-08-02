import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/component/delete_button.dart';

class DataCellUtil {
  static DataCell newDellDataCell(VoidCallback voidCallback) {
    return DataCell(DeleteButton(voidCallback));
  }
}
