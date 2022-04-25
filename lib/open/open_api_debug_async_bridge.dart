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

import 'package:dart_eval/dart_eval_bridge.dart';
import 'package:paas_dashboard_flutter/open/open_api_debug_async.dart';

class OpenApiDebugAsyncBridge with $Bridge<OpenApiDebugAsync> {
  static const $type = BridgeTypeReference.unresolved(
      BridgeUnresolvedTypeReference(
          'package:paas_dashboard_flutter/open/open_api_debug_async.dart', 'OpenApiDebugAsync'),
      []);

  static const $declaration = BridgeClassDeclaration($type, isAbstract: false, constructors: {}, methods: {
    'helloWorld': BridgeMethodDeclaration(
        false,
        BridgeFunctionDescriptor(
            BridgeTypeAnnotation(
                BridgeTypeReference.unresolved(BridgeUnresolvedTypeReference('dart:core', 'Future'), []), false),
            {},
            [],
            {})),
  }, getters: {}, setters: {}, fields: {});

  @override
  $Value? $bridgeGet(String identifier) {
    // TODO: implement $bridgeGet
    throw UnimplementedError();
  }

  @override
  void $bridgeSet(String identifier, $Value value) {
    // TODO: implement $bridgeSet
  }
}
