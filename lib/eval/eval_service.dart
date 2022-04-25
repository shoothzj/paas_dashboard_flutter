//
// Licensed to the Apache Software Foundation (ASF) under one
// or more contributor license agreements.  See the NOTICE file
// distributed with this work for additional information
// regarding copyright ownership.  The ASF licenses this file
// to you under the Apache License, Version 2.0 (the
// "License"); you may not use this file except in compliance
// with the License.  You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.
//

import 'package:dart_eval/dart_eval.dart';
import 'package:paas_dashboard_flutter/open/open_api_debug_async_bridge.dart';
import 'package:paas_dashboard_flutter/open/open_api_debug_sync_bridge.dart';

class EvalService {
  static void evalPiece(String piece) {
    var compiler = Compiler();
    compiler.defineBridgeClasses([OpenApiDebugSyncBridge.$declaration]);
    compiler.defineBridgeClasses([OpenApiDebugAsyncBridge.$declaration]);
    final code = "" +
        "import 'package:paas_dashboard_flutter/open/open_api_debug_async.dart';\n" +
        "import 'package:paas_dashboard_flutter/open/open_api_debug_sync.dart';\n" +
        "void main() async {\n" +
        "final openApiDebugSync = OpenApiDebugSync();\n" +
        "final openApiDebugAsync = OpenApiDebugAsync();\n" +
        piece +
        "\n" +
        "}";
    final program = compiler.compile({
      'package:example': {'main.dart': code}
    });
    final runtime = Runtime.ofProgram(program);
    runtime.setup();
    runtime.executeNamed(0, 'main');
  }
}
