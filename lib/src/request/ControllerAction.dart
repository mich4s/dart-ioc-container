import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/annotations/parameters/ActionParam.dart';
import 'package:ioc/src/exceptions/CoreException.dart';
import 'package:shelf/shelf.dart';

typedef dynamic MiddyCallback(Request request, dynamic previous);

class ControllerAction {
  void register(String method, String url, Type type, Symbol action) async {
    var controller = await Application().getComponent(type);
    ClassMirror tmp = reflectType(type);
    MethodMirror actionMirror = tmp.declarations[action];
    Map<Symbol, List<Function>> parameters =
        this._prepareMethodParameters(actionMirror);
    CreateRouteMapping().mapRequest(method, url, (Request request) async {
      try {
        List actionParams = await this._resolveParameters(parameters, request);
        var response = reflect(controller).invoke(action, actionParams);
        return Response.ok(response.reflectee.toString());
      } catch (e) {
        if (e is CoreException) {
          return Response(e.code, body: e.toString());
        } else {
          return Response.internalServerError();
        }
      }
    });
  }

  Future<List<dynamic>> _resolveParameters(
    Map<Symbol, List<MiddyCallback>> parameters,
    Request request,
  ) async {
    List<dynamic> response = [];
    for (Symbol name in parameters.keys) {
      List<MiddyCallback> middlewares = parameters[name];
      var value;
      for (var middleware in middlewares) {
        value = await middleware(request, value);
      }
      response.add(value);
    }
    return response;
  }

  Map<Symbol, List<MiddyCallback>> _prepareMethodParameters(MethodMirror mirror) {
    Map<Symbol, List<MiddyCallback>> parameters = {};
    var parametersMirror = mirror.parameters;
    for (var paramMirror in parametersMirror) {
      parameters[paramMirror.simpleName] = [];
      for (var metadata in paramMirror.metadata) {
        if (metadata.reflectee is ActionParam) {
          parameters[paramMirror.simpleName].add(this
              ._registerParameterMiddleware(
                  paramMirror.simpleName, metadata.reflectee));
        }
      }
    }
    return parameters;
  }

  MiddyCallback _registerParameterMiddleware(Symbol name, ActionParam annotation) {
    return annotation.onExecute;
  }
}
