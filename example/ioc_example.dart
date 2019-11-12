library ioc_example;

import 'package:ioc/ioc.dart';

main() {
  Container container = Container();
  container.loadPackage().then((s) {
    Map registeredComponents = container.components;
    assert(registeredComponents.length == 4);
    CreateRouteMapping().serve();
  });
}
