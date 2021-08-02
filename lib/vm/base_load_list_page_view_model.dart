import 'package:flutter/material.dart';

typedef Converter = DataRow Function(dynamic item);

abstract class BaseLoadListPageViewModel<T> extends DataTableSource {
  bool loading = true;

  Exception? loadException;

  Exception? opException;

  List<T> displayList = <T>[];

  List<T> fullList = <T>[];

  Converter? converter;

  void setDataConverter(Converter converter) {
    this.converter = converter;
  }

  /// call loadSuccess to set loading to false and clear the exceptions
  void loadSuccess() {
    loading = false;
    loadException = null;
  }

  @override
  DataRow? getRow(int index) {
    if (converter == null) {
      return null;
    }
    var item = this.displayList[index];
    return converter!(item);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => displayList.length;

  @override
  int get selectedRowCount => 0;
}
