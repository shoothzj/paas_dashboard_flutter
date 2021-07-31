import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class BaseLoadListViewModel<T> extends BaseLoadViewModel {
  bool loading = true;

  Exception? loadException;

  Exception? opException;

  List<T> displayList = <T>[];

  List<T> fullList = <T>[];
}
