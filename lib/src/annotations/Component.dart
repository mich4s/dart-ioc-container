import 'package:ioc/src/component_bootstrap/ComponentType.dart';

abstract class Component {
  final ComponentType componentType = ComponentType.prototype;

  void onRegister(Type type);
}
