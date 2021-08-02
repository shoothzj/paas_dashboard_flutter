import 'package:flutter/material.dart';

class BaseLoadViewModel extends ChangeNotifier {
  bool loading = true;

  Exception? loadException;

  Exception? opException;

  /// call loadSuccess to set loading to false and clear the exceptions
  void loadSuccess() {
    loading = false;
    loadException = null;
  }
}
