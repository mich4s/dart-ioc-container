import 'package:ioc/src/annotations/Component.dart';
import 'package:ioc/src/component_bootstrap/ComponentType.dart';

class Singleton implements Component {
  const Singleton();

  @override
  void onRegister(Type type) {
    print("Registered singleton");
  }

  @override
  ComponentType get componentType => ComponentType.singleton;
}
