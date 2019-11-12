import 'dart:mirrors';

import 'package:ioc/ioc.dart';

class InjectableFieldScanner {
  static InjectableFieldScanner _instance = InjectableFieldScanner._internal();

  InjectableFieldScanner._internal();

  factory InjectableFieldScanner() {
    return InjectableFieldScanner._instance;
  }

  Map<Symbol, DeclarationMirror> getAll(ClassMirror classMirror) {
    Map<Symbol, DeclarationMirror> haystack = this._getAllFields(classMirror);
    return this._getInjectableFields(haystack);
  }

  Map<Symbol, DeclarationMirror> _getAllFields(ClassMirror classMirror) {
    return classMirror.declarations;
  }

  Map<Symbol, DeclarationMirror> _getInjectableFields(
      Map<Symbol, DeclarationMirror> haystack) {
    Map<Symbol, DeclarationMirror> toInject = {};
    haystack.forEach((Symbol name, DeclarationMirror mirror) {
      try {
        mirror.metadata.firstWhere((InstanceMirror tester) {
          return tester.reflectee is Inject;
        });
        toInject[name] = mirror;
      } catch (e) {}
    });
    return toInject;
  }
}
