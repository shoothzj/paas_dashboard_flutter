import 'package:flutter/material.dart';
import 'package:paas_dashboard_flutter/ui/util/alert_util.dart';
import 'package:paas_dashboard_flutter/vm/base_load_list_page_view_model.dart';
import 'package:paas_dashboard_flutter/vm/base_load_view_model.dart';

class ExceptionUtil {
  /// opException 加载一次后即消除
  static void processOpException(BaseLoadViewModel vm, BuildContext context) {
    if (vm.opException == null) {
      return;
    }
    Exception ex = vm.opException!;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AlertUtil.exceptionDialog(ex, context);
    });
    vm.opException = null;
  }

  static void processOpExceptionPageable(
      BaseLoadListPageViewModel vm, BuildContext context) {
    if (vm.opException == null) {
      return;
    }
    Exception ex = vm.opException!;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AlertUtil.exceptionDialog(ex, context);
    });
    vm.opException = null;
  }

  static void processLoadException(BaseLoadViewModel vm, BuildContext context) {
    if (vm.loadException == null) {
      return;
    }
    Exception ex = vm.loadException!;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AlertUtil.exceptionDialog(ex, context);
    });
  }

  static void processLoadExceptionPageable(
      BaseLoadListPageViewModel vm, BuildContext context) {
    if (vm.loadException == null) {
      return;
    }
    Exception ex = vm.loadException!;
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      AlertUtil.exceptionDialog(ex, context);
    });
    vm.loadException = null;
  }
}
