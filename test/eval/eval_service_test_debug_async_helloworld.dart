import 'package:paas_dashboard_flutter/eval/eval_service.dart';

void main() async {
  EvalService.evalPiece('''
      print(openApiDebugAsync.helloWorld());
      print(openApiDebugAsync.echo("Hi!"));
    ''');
}
