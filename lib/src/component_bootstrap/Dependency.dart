import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/component_bootstrap/ComponentBootstrap.dart';

class Dependency {
  final ComponentBootstrap componentBootstrap;
  final Map<String, Type> _injections = {};
  final List<Symbol> _postConstructors = [];

  Dependency(this.componentBootstrap);

  Future<Object> get component async {
    Object component = this.componentBootstrap.getComponent(_injections);
    InstanceMirror instanceMirror = reflect(component);
    await this._injectDependencies(instanceMirror);
    await this._invokePostConstructors(instanceMirror);
    return component;
  }

  void addInjection(String name, Type type) {
    this._injections.addAll({name: type});
  }

  void addPostConstructors(List<Symbol> postConstructors) {
    this._postConstructors.addAll(postConstructors);
  }

  void _invokePostConstructors(InstanceMirror instanceMirror) async {
    for(Symbol name in this._postConstructors) {
      await instanceMirror.invoke(name, []);
    }
  }

  void _injectDependencies(InstanceMirror instanceMirror) async {

    for(String name in this._injections.keys) {
      Type type = this._injections[name];
      instanceMirror.setField(Symbol(name), await Application().getComponent(type));
    }
  }
}
