import 'dart:mirrors';

import 'package:ioc/ioc.dart';
import 'package:ioc/src/component_bootstrap/Dependency.dart';

class PostConstructorRegisterer {
  void register(Map<Symbol, DeclarationMirror> fields, Dependency dependency) {
    List<Symbol> postConstructors = this._getPostConstructors(fields);
    this._registerPostConstructors(postConstructors, dependency);
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

  void _registerPostConstructors(List<Symbol> functions, Dependency dep) {
    dep.addPostConstructors(functions);
  }
}
