import 'package:ioc/src/annotations/Component.dart';
import 'package:ioc/src/component_bootstrap/ComponentType.dart';

class Prototype implements Component {
  const Prototype();

  @override
  void onRegister(Type type) {
    print("Registered Prototype");
  }

  @override
  ComponentType get componentType => ComponentType.prototype;
}
