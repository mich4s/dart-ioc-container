import 'dart:mirrors';

import 'package:ioc/src/component_bootstrap/ComponentBootstrap.dart';

class PrototypeBootstrap extends ComponentBootstrap {
  Type _component;

  @override
  Object getComponent(Map<String, Type> injections) {
    InstanceMirror componentInstance = this.inject(injections, this._component);
    return componentInstance.reflectee;
  }

  @override
  setComponent(Type component) {
    this._component = component;
  }
}
