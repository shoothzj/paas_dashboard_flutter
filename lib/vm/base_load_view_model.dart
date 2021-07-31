import 'package:flutter/material.dart';

class BaseLoadViewModel extends ChangeNotifier {
  bool loading = true;

  Exception? loadException;

  Exception? opException;
}
