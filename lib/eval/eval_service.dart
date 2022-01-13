import 'package:dart_eval/dart_eval.dart';
import 'package:paas_dashboard_flutter/open/open_api_debug_sync_eval_help.dart';

class EvalService {
  static void eval(String piece) {
    var parser = Parse();
    parser.define(EvalOpenApiSyncDebug.declaration);
    final code = "void main() async {" + "\n" + "final openApiSyncDebug = OpenApiSyncDebug();\n" + piece + "\n" + "}";
    final func = parser.parse(code);
    func('main', []);
  }
}
