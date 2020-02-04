library ioc_example;

import 'package:ioc/ioc.dart';
import './controllers/UserController.dart';

main() async {
  Application application = Application();
  await application.registerComponents([
    UserController
  ]);
  await CreateRouteMapping().serve();
}
