import 'dart:mirrors';

import 'package:ioc/src/PackageManager.dart';
import 'package:ioc/src/annotations/Component.dart';
import 'package:ioc/src/component_bootstrap/ComponentBootstrap.dart';
import 'package:ioc/src/component_bootstrap/ComponentType.dart';
import 'package:ioc/src/component_bootstrap/Dependency.dart';
import 'package:ioc/src/component_registrator/ChildRegisterer.dart';
import 'package:ioc/src/component_registrator/RegisterInvoker.dart';

class Container {
  static Container _instance = Container._internal();

  MirrorSystem mirrorSystem = currentMirrorSystem();
  IsolateMirror isolateMirror;
  Uri libraryUri;

  Container._internal() {
    this.isolateMirror = mirrorSystem.isolate;
    this.libraryUri = this.isolateMirror.rootLibrary.uri;
  }

  factory Container() {
    return Container._instance;
  }

  Map<Type, Dependency> _components = {};

  Map<Type, Dependency> get components => _components;

  Future loadPackage() async {
    PackageManager packageManager = PackageManager.fromUri(this.libraryUri);
    List<ClassMirror> classes =
        await packageManager.getPackageClasses(this.isolateMirror);
    classes.forEach((ClassMirror classMirror) {
      this.registerComponent(classMirror.reflectedType, classMirror);
    });
  }

  dynamic getComponent(Type component) {
    if (this._components[component] != null) {
      return this._components[component].component;
    }
    return null;
  }

  ClassMirror getComponentReflection(Type component) {
    return reflectClass(component);
  }

  void registerComponents(List<Type> components) {
    components.forEach((Type component) {
      ClassMirror componentReflection = this.getComponentReflection(component);
      this.registerComponent(component, componentReflection);
    });
  }

  void registerComponent(Type type, ClassMirror reflection) {
    if (this._components[type] == null) {
      try {
        ComponentBootstrap bootstrap = ComponentBootstrap.create(
            this._getComponentType(reflection.metadata));
        bootstrap.setComponent(type);
        Dependency dependency = Dependency(bootstrap);
        this._components[type] = dependency;
        ChildRegisterer().registerComponentChild(reflection, dependency);
        RegisterInvoker().invokeOnRegisterMethod(type, reflection);
      } catch (e) {
        print("Non injectable component ${type.toString()}");
      }
    }
  }

  ComponentType _getComponentType(List<InstanceMirror> metadata) {
    Component component = metadata.firstWhere((InstanceMirror instanceMirror) {
      return instanceMirror.reflectee is Component;
    }).reflectee;
    return component.componentType;
  }
}
