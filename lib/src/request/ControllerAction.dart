import 'dart:convert';
import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/annotations/parameters/ActionParam.dart';
import 'package:ioc/src/exceptions/CoreException.dart';
import 'package:shelf/shelf.dart';

class ControllerAction {
  void register(String method, String url, Type type, Symbol action) {
    CreateRouteMapping().mapRequest(method, url, (Request request) async {
      try {
        var controller = Container().getComponent(type);
        ClassMirror tmp = reflectType(type);
        MethodMirror actionMirror = tmp.declarations[action];
        Map<String, dynamic> requestBody = await this._requestBody(request);
        List parameters = this._getParamsList(actionMirror.parameters,
            request.context['shelf_router/params'], requestBody);
        var response = reflect(controller).invoke(action, parameters);
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

  List<dynamic> _getParamsList(List<ParameterMirror> parameters,
      Map<String, dynamic> routeParams, Map<String, dynamic> requestBody) {
    List<dynamic> parsed = [];
    parameters.forEach((ParameterMirror parameter) {
      try {
        ActionParam actionParam = parameter.metadata
            .firstWhere((InstanceMirror instanceMirror) =>
                instanceMirror.reflectee is ActionParam)
            .reflectee;
        parsed.add(actionParam.perform(
          routeParams: routeParams,
          requestBody: requestBody,
        ));
      } catch (e) {
        if (e is CoreException) {
          rethrow;
        }
      }
    });
    return parsed;
  }

  Future<Map<String, dynamic>> _requestBody(Request request) async {
    String body = await request.readAsString();
    try {
      return json.decode(body);
    } catch (e) {
      return {};
    }
  }
}
