// Create a library-local lexical scope so that all classes and functions within
// a library can always access each other. Inherit from the empty scope.
import 'package:dart_eval/dart_eval.dart';
import 'package:paas_dashboard_flutter/open/open_api_debug_sync.dart';

final openDebugType = EvalType('OpenApiSyncDebug', 'OpenApiSyncDebug',
    'package:paas_dashboard_flutter/open/open_api_debug_sync.dart', [EvalType.objectType], true);

class EvalOpenApiSyncDebug extends OpenApiSyncDebug
    with
        ValueInterop<EvalOpenApiSyncDebug>,
        EvalBridgeObjectMixin<EvalOpenApiSyncDebug>,
        BridgeRectifier<EvalOpenApiSyncDebug> {
  EvalOpenApiSyncDebug() : super();

  static final BridgeInstantiator<EvalOpenApiSyncDebug> _evalInstantiator =
      (String constructor, List<dynamic> pos, Map<String, dynamic> named) {
    return EvalOpenApiSyncDebug();
  };

  static final declaration = DartBridgeDeclaration(
      visibility: DeclarationVisibility.PUBLIC,
      declarator: (ctx, lex, cur) =>
          {'OpenApiSyncDebug': EvalField('OpenApiSyncDebug', cls = clsGen(lex), null, Getter(null))});

  static final clsGen = (lexicalScope) => EvalBridgeClass(
      [DartConstructorDeclaration('', [])], openDebugType, lexicalScope, OpenApiSyncDebug, _evalInstantiator);

  static late EvalBridgeClass cls;

  @override
  EvalBridgeData evalBridgeData = EvalBridgeData(cls);

  static EvalValue evalMakeWrapper(OpenApiSyncDebug? target) {
    if (target == null) {
      return EvalNull();
    }
    return EvalRealObject(target, cls: cls, fields: {
      'name': EvalField(
          'name',
          null,
          null,
          Getter(EvalCallableImpl(
              (lexical, inherited, generics, args, {target}) => EvalString(target?.realValue!.name!)))),
      'helloWorld': EvalField(
          'helloWorld',
          EvalFunctionImpl(DartMethodBody(callable: (lex, s2, gen, params, {EvalValue? target}) {
            return EvalRealObject<Future<String>>(target!.realValue!.helloWorld());
          }), []),
          null,
          Getter(null)),
      'echo': EvalField(
          'echo',
          EvalFunctionImpl(DartMethodBody(callable: (lex, s2, gen, params, {EvalValue? target}) {
            return EvalRealObject<Future<String>>(target!.realValue!.helloWorld());
          }), []),
          null,
          Getter(null)),
    });
  }

  @override
  String helloWorld() {
    return bridgeCall("helloWorld", []);
  }

  @override
  String echo(String args) {
    return bridgeCall("echo", [EvalString(args)]);
  }

  @override
  String get name {
    final _f = evalBridgeTryGetField('name');
    if (_f != null) return _f.evalReifyFull();
    return super.name;
  }

  @override
  EvalValue evalGetField(String name, {bool internalGet = false}) {
    switch (name) {
      case 'name':
        final _f = evalBridgeTryGetField('name');
        if (_f != null) return _f;
        return EvalString(super.name);
      case 'helloWorld':
        return EvalFunctionImpl(DartMethodBody(callable: (lex, s2, gen, params, {EvalValue? target}) {
          return EvalString(super.helloWorld());
        }), []);
      case 'echo':
        return EvalFunctionImpl(DartMethodBody(callable: (lex, s2, gen, params, {EvalValue? target}) {
          EvalString params0 = params[0].value as EvalString;
          return EvalString(super.echo(params0.realValue!));
        }), []);
      default:
        return super.evalGetField(name, internalGet: internalGet);
    }
  }
}
