import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/component_bootstrap/Dependency.dart';
import 'package:ioc/src/component_registrator/InjectableFieldScanner.dart';

class ChildRegisterer {
  void registerComponentChild(ClassMirror mirror, Dependency dep) {
    Map<Symbol, DeclarationMirror> declarations =
        InjectableFieldScanner().getAll(mirror);
    Map<Symbol, VariableMirror> variables = this._getAllVariables(declarations);
    this._addInjections(variables, dep);
    dep.addPostConstructors(this._getPostConstructors(mirror.declarations));
  }

  Map<Symbol, DeclarationMirror> _getAllVariables(
      Map<Symbol, DeclarationMirror> allDeclarations) {
    Map<Symbol, VariableMirror> variables = {};
    allDeclarations.forEach((Symbol name, DeclarationMirror mirror) {
      if (mirror is VariableMirror) {
        variables[name] = mirror;
      }
    });
    return variables;
  }

  void _addInjections(Map<Symbol, VariableMirror> variables, Dependency dep) {
    variables.forEach((Symbol name, VariableMirror variable) {
      Type type = variable.type.reflectedType;
      dep.addInjection(MirrorSystem.getName(name), type);
      Application().registerComponent(type, reflectClass(type));
    });
  }

  List<Symbol> _getPostConstructors(Map<Symbol, DeclarationMirror> allFields) {
    List<Symbol> postConstructors = [];
    allFields.forEach((Symbol name, DeclarationMirror mirror) {
      try {
        mirror.metadata.firstWhere((InstanceMirror tester) {
          return tester.reflectee is PostConstruct;
        });
        postConstructors.add(name);
      } catch (e) {}
    });
    return postConstructors;
  }
}
