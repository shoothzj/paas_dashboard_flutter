import 'package:flutter/material.dart';

abstract class BaseLoadListPageViewModel<T> extends DataTableSource {
  bool loading = true;

  Exception? loadException;

  Exception? opException;

  List<T> displayList = <T>[];

  List<T> fullList = <T>[];

  Function(dynamic)? callback;

  void wrapCallback(Function(dynamic) callback) {
    this.callback = callback;
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => displayList.length;

  @override
  int get selectedRowCount => 0;
}
