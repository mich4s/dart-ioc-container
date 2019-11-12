import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/component_bootstrap/ComponentBootstrap.dart';

class Dependency {
  final ComponentBootstrap componentBootstrap;
  final Map<String, Type> _injections = {};
  final List<Symbol> _postConstructors = [];

  Dependency(this.componentBootstrap);

  Object get component {
    Object component = this.componentBootstrap.getComponent(_injections);
    InstanceMirror instanceMirror = reflect(component);
    this._injectDependencies(instanceMirror);
    this._invokePostConstructors(instanceMirror);
    return component;
  }

  void addInjection(String name, Type type) {
    this._injections.addAll({name: type});
  }

  void addPostConstructors(List<Symbol> postConstructors) {
    this._postConstructors.addAll(postConstructors);
  }

  void _invokePostConstructors(InstanceMirror instanceMirror) {
    this._postConstructors.forEach((Symbol name) {
      instanceMirror.invoke(name, []);
    });
  }

  void _injectDependencies(InstanceMirror instanceMirror) {
    this._injections.forEach((String name, Type type) {
      instanceMirror.setField(Symbol(name), Container().getComponent(type));
    });
  }
}
