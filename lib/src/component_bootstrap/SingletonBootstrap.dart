import 'dart:mirrors';

import 'package:ioc/src/component_bootstrap/ComponentBootstrap.dart';

class SingletonBootstrap extends ComponentBootstrap {
  Object _instance;
  Type _component;

  Object getComponent(Map<String, Type> injections) {
    if (_instance == null) {
      InstanceMirror componentInstance =
          this.inject(injections, this._component);
      this._instance = componentInstance.reflectee;
    }
    return _instance;
  }

  @override
  setComponent(Type component) {
    this._component = component;
  }
}
