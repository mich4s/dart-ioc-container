import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/annotations/RequestMapping.dart';
import 'package:ioc/src/request/ControllerAction.dart';

class Controller extends Singleton {
  final String url;

  const Controller(this.url);

  @override
  void onRegister(Type type) {
    ClassMirror controllerMirror = Application().getComponentReflection(type);
    controllerMirror.instanceMembers
        .forEach((Symbol action, MethodMirror method) {
      try {
        RequestMapping mapper = this._getRequestMapping(method);
        this._registerControllerAction(
            mapper.method, this.url + mapper.url, type, action);
      } catch (e) {
//        print(e);
      }
    });
    super.onRegister(type);
  }

  void _registerControllerAction(
      String method, String url, Type type, Symbol action) {
    ControllerAction().register(method, url, type, action);
  }

  RequestMapping _getRequestMapping(MethodMirror method) {
    return method.metadata
        .firstWhere((InstanceMirror meta) => meta.reflectee is RequestMapping)
        .reflectee;
  }
}
