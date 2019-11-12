import 'dart:mirrors';

import 'package:ioc/src/annotations/parameters/ActionParam.dart';
import 'package:ioc/src/annotations/parameters/validators/FieldValidation.dart';
import 'package:ioc/src/exceptions/ValidationException.dart';

class Valid extends ActionParam {
  final Type type;

  const Valid(this.type);

  @override
  perform({Map<String, String> routeParams, Map<String, dynamic> requestBody}) {
    ClassMirror reflected = reflectType(this.type);
    return this._constructModel(reflected, requestBody);
  }

  _constructModel(ClassMirror model, Map<String, dynamic> requestBody) {
    InstanceMirror instance =
        model.newInstance(Symbol('fromJson'), [requestBody]);
    instance = this._validateFieldProperties(instance);
    return instance.reflectee;
  }

  _validateFieldProperties(InstanceMirror instanceMirror) {
    List<String> failed = [];
    instanceMirror.type.declarations
        .forEach((Symbol name, DeclarationMirror declaration) {
      if (declaration is VariableMirror) {
        try {
          if (!this
              ._validateProperty(instanceMirror.getField(name), declaration)) {
            failed.add(MirrorSystem.getName(name));
          }
        } catch (e) {}
      }
    });
    if (failed.isNotEmpty) {
      throw ValidationException(failed.join(', '));
    }
    return instanceMirror;
  }

  bool _validateProperty(InstanceMirror value, DeclarationMirror declaration) {
    try {
      declaration.metadata.forEach((InstanceMirror metadata) {
        if (metadata.reflectee is FieldValidation) {
          if (!(metadata.reflectee as FieldValidation)
              .validate(value.reflectee)) {
            throw Error();
          }
        }
      });
      return true;
    } catch (e) {
      return false;
    }
  }
}
