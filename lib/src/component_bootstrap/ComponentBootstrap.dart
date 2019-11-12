import 'dart:mirrors';

import 'package:ioc/src/Container.dart';
import 'package:ioc/src/component_bootstrap/ComponentType.dart';
import 'package:ioc/src/component_bootstrap/PrototypeBootstrap.dart';
import 'package:ioc/src/component_bootstrap/SingletonBootstrap.dart';
import 'package:meta/meta.dart';

abstract class ComponentBootstrap {
  static ComponentBootstrap create(ComponentType componentType) {
    switch (componentType) {
      case ComponentType.singleton:
        return SingletonBootstrap();
      default:
        return PrototypeBootstrap();
    }
  }

  Object getComponent(Map<String, Type> injections);

  setComponent(Type component);

  @protected
  Function postConstruct;

  @protected
  InstanceMirror inject(Map<String, Type> injections, Type type) {
    Map<Symbol, Type> toInject = {};
    ClassMirror component = reflectClass(type);
    Symbol constructorSymbol;
    for (DeclarationMirror declaration in component.declarations.values) {
      String simpleName = MirrorSystem.getName(declaration.simpleName);
      if (injections.containsKey(simpleName)) {
        toInject[declaration.simpleName] = injections[simpleName];
      } else if (declaration is MethodMirror && declaration.isConstructor) {
        constructorSymbol = declaration.constructorName;
      }
    }
    InstanceMirror componentInstance =
        component.newInstance(constructorSymbol, []);
    toInject.forEach((Symbol name, Type type) {
      Object dependency = Container().getComponent(type);
      try {
        componentInstance.setField(name, dependency);
      } catch (e) {
//        print(e);
      }
    });
    return componentInstance;
  }
}
