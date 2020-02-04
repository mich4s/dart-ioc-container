import 'package:ioc/ioc.dart';
import 'package:ioc/src/annotations/parameters/RouteParam.dart';
import 'package:ioc/src/annotations/parameters/validators/Valid.dart';

import '../messages/User.dart';
import '../services/PrototypeService.dart';
import '../services/UserService.dart';

@Controller("/users")
class UserController {
  @PostConstruct()
  void initialize() {
    print("Pre initialization UserController");
  }

  @Inject() //singleton
  UserService userService;

  @Inject() //prototype
  PrototypeService prototypeService;

  @RequestMapping(method: 'GET', url: '/<id>')
  String index() {
    return "${userService.temp}:${prototypeService.temp}";
  }

  @RequestMapping(method: 'GET', url: '/param/<id>')
  String withParam(@RouteParam('id', type: int) int id) {
    return '${id}';
  }

  @RequestMapping(method: 'POST', url: '/')
  String postAction(@Valid(User) user) {
    return '${user.id}';
  }
}
