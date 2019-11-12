import 'dart:mirrors';

import 'package:ioc/ioc.dart';

class RegisterInvoker {
  static RegisterInvoker _instance = RegisterInvoker._internal();

  RegisterInvoker._internal();

  factory RegisterInvoker() {
    return RegisterInvoker._instance;
  }

  bool invokeOnRegisterMethod(Type type, ClassMirror reflection) {
    try {
      InstanceMirror instanceMirror = this._getInstanceMirror(reflection);
      this._invokeOnRegister(type, instanceMirror.reflectee);
      return true;
    } catch (e) {
      print("Could not invoke ${type} registration");
      return false;
    }
  }

  InstanceMirror _getInstanceMirror(ClassMirror reflection) {
    InstanceMirror instanceMirror = reflection.metadata.firstWhere(
        (InstanceMirror metadata) => metadata.reflectee is Component);
    return instanceMirror;
  }

  void _invokeOnRegister(Type type, Component componentMeta) {
    componentMeta.onRegister(type);
  }
}
